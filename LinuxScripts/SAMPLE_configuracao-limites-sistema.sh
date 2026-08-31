#!/usr/bin/env bash
#
# ⚠️ GERADO PELO CLAUDE.ai: Script contendo exemplos de limitações que podemos implementar no sistema para evitar travamento
# No caso, isso serve pra priorizar o sistema rodando, e impedir que outros processos se sobressaiam sobre o sistema.
# Este script reunie diversar técnicas, mas a que EU PESSOALMENTE mais uso, é a de priorizar o desktop, por que aí você pode reagir manualmente aos travamentos.
#
# setup-oom-protection.sh
#
# Protege a estação de trabalho contra congelamento por exaustão de RAM
# ou saturação de CPU/IO causada por processos de desenvolvimento
# (next dev, tsx watch, builds, containers, VMs).
#
# Estratégia em três camadas:
#   1. Adiar o problema      -> zram
#   2. Matar antes de travar -> earlyoom
#   3. Impedir a disputa     -> cgroups (CPUWeight/IOWeight/MemoryMax)
#   + válvulas de escape     -> SysRq e atalho de teclado
#
# Idempotente: pode rodar quantas vezes quiser.
# Uso: sudo ./setup-oom-protection.sh
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuração
# ---------------------------------------------------------------------------

ENABLE_EARLYOOM=true      # daemon que mata antes do congelamento
ENABLE_ZRAM=true          # swap comprimida em RAM
ENABLE_SYSRQ=true         # Alt+SysRq+F como último recurso
ENABLE_DESKTOP_PRIO=true  # prioridade de CPU/IO para a sessão gráfica
ENABLE_PM2_LIMITS=true    # coleira no serviço do PM2
ENABLE_KILLHOG=true       # script + atalho para matar o maior consumidor

# Limites do PM2 — ajuste conforme a RAM e o número de cores da máquina.
PM2_MEMORY_MAX="3G"
PM2_SWAP_MAX="512M"
PM2_CPU_QUOTA="300%"      # 300% = no máximo 3 cores

# Limiares do earlyoom: avisa em X% livre, mata em Y%.
EARLYOOM_MEM="8,4"
EARLYOOM_SWAP="10,5"

# ATENÇÃO: earlyoom compara contra /proc/PID/comm, que o kernel trunca
# em 15 caracteres. Nomes maiores precisam ser escritos truncados —
# por isso 'gnome-session-b' e não 'gnome-session-binary'.
# E nada de aspas simples aqui: o systemd expande $EARLYOOM_ARGS sem
# processamento de shell, então elas entrariam literais na regex.
EARLYOOM_AVOID='^(systemd|Xorg|Xwayland|gnome-shell|gnome-session-b|sshd|tailscaled|dbus-daemon|kwin_x11|plasmashell)$'
EARLYOOM_PREFER='^(chrome|chromium|firefox|node|next-server|esbuild|code|java|vmware-vmx|dockerd|containerd)$'

# ---------------------------------------------------------------------------
# Utilidades
# ---------------------------------------------------------------------------

RED=$'\e[31m'; GREEN=$'\e[32m'; YELLOW=$'\e[33m'; BLUE=$'\e[34m'; RESET=$'\e[0m'

log()  { printf '%s==>%s %s\n' "$BLUE" "$RESET" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%s  !!%s %s\n' "$YELLOW" "$RESET" "$*"; }
die()  { printf '%serro%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Rode com sudo."

# Usuário real por trás do sudo — precisamos dele para o nome do
# serviço do PM2 e para instalar o script no home certo.
TARGET_USER="${SUDO_USER:-}"
[[ -n "$TARGET_USER" && "$TARGET_USER" != "root" ]] \
  || die "Rode via 'sudo', não como root direto (preciso saber o usuário alvo)."

TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
[[ -d "$TARGET_HOME" ]] || die "Home de $TARGET_USER não encontrado."

log "Usuário alvo: $TARGET_USER ($TARGET_HOME)"

# Grava um arquivo só se o conteúdo mudou. Faz backup do anterior.
write_file() {
  local path="$1" content="$2"
  if [[ -f "$path" ]] && [[ "$(cat "$path")" == "$content" ]]; then
    ok "$path já está correto"
    return 0
  fi
  [[ -f "$path" ]] && cp -a "$path" "${path}.bak.$(date +%Y%m%d%H%M%S)"
  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$content" > "$path"
  ok "$path escrito"
  return 0
}

apt_install() {
  local pkg="$1"
  if dpkg -s "$pkg" &>/dev/null; then
    ok "$pkg já instalado"
  else
    log "Instalando $pkg..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "$pkg"
  fi
}

# ---------------------------------------------------------------------------
# 1. earlyoom — mata antes do congelamento
# ---------------------------------------------------------------------------

setup_earlyoom() {
  log "earlyoom"
  apt_install earlyoom

  write_file /etc/default/earlyoom "\
# Gerenciado por setup-oom-protection.sh
# -r 60          : reporta o estado da memória a cada 60s (histórico útil)
# -m / -s        : limiares 'avisa,mata' em % livre de RAM / swap
# --avoid        : nunca matar (quebraria a sessão)
# --prefer       : matar preferencialmente (suspeitos de sempre)
# Nomes limitados a 15 chars (kernel trunca /proc/PID/comm).
EARLYOOM_ARGS=\"-r 60 -m ${EARLYOOM_MEM} -s ${EARLYOOM_SWAP} --avoid ${EARLYOOM_AVOID} --prefer ${EARLYOOM_PREFER}\""

  systemctl enable --now earlyoom &>/dev/null
  systemctl restart earlyoom
  ok "earlyoom ativo (journalctl -u earlyoom -f para acompanhar)"
}

# ---------------------------------------------------------------------------
# 2. zram — swap comprimida, adia o problema
# ---------------------------------------------------------------------------

setup_zram() {
  log "zram"
  apt_install systemd-zram-generator

  write_file /etc/systemd/zram-generator.conf "\
# Gerenciado por setup-oom-protection.sh
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100"

  systemctl daemon-reload
  systemctl restart systemd-zram-setup@zram0.service 2>/dev/null || true
  ok "zram configurado (confira com: zramctl)"
}

# ---------------------------------------------------------------------------
# 3. SysRq — válvula de escape do kernel (só funciona para RAM)
# ---------------------------------------------------------------------------

setup_sysrq() {
  log "SysRq"
  write_file /etc/sysctl.d/99-sysrq.conf "\
# Gerenciado por setup-oom-protection.sh
# Habilita todas as funções SysRq. Alt+SysRq+F dispara o OOM killer.
# Observação: o OOM killer escolhe a vítima só por memória (RSS+swap+
# page tables). Não serve contra saturação de CPU.
kernel.sysrq=1"

  sysctl --system &>/dev/null
  ok "SysRq habilitado (Alt+PrtScn+F dispara o OOM killer)"
}

# ---------------------------------------------------------------------------
# 4. Prioridade da sessão gráfica — o que evita o congelamento por CPU
# ---------------------------------------------------------------------------

setup_desktop_priority() {
  log "Prioridade da sessão de usuário"
  write_file /etc/systemd/system/user@.service.d/10-priority.conf "\
# Gerenciado por setup-oom-protection.sh
# Peso relativo, não limite: a sessão gráfica ganha a disputa por CPU e
# disco contra serviços de peso menor, mas ainda usa a máquina inteira
# quando ela está ociosa.
[Service]
CPUWeight=1000
IOWeight=1000"

  systemctl daemon-reload
  ok "Sessão gráfica com prioridade alta"
}

# ---------------------------------------------------------------------------
# 5. Coleira no PM2
# ---------------------------------------------------------------------------

setup_pm2_limits() {
  log "Limites do PM2"
  local unit="pm2-${TARGET_USER}"

  if ! systemctl list-unit-files "${unit}.service" &>/dev/null \
     || ! systemctl cat "${unit}.service" &>/dev/null; then
    warn "Serviço ${unit}.service não existe — pulando."
    warn "Se instalar o PM2 depois, rode este script novamente."
    return 0
  fi

  write_file "/etc/systemd/system/${unit}.service.d/10-limits.conf" "\
# Gerenciado por setup-oom-protection.sh
# Cerca de verdade: configuração de app se contorna, cgroup não.
[Service]
MemoryMax=${PM2_MEMORY_MAX}
MemorySwapMax=${PM2_SWAP_MAX}
CPUQuota=${PM2_CPU_QUOTA}
CPUWeight=20
IOWeight=20"

  systemctl daemon-reload
  systemctl restart "$unit" 2>/dev/null || warn "Reinicie $unit manualmente."
  ok "PM2 limitado a ${PM2_MEMORY_MAX} / ${PM2_CPU_QUOTA}"
}

# ---------------------------------------------------------------------------
# 6. kill-hog — mata o maior consumidor de CPU, preservando o essencial
# ---------------------------------------------------------------------------

setup_killhog() {
  log "kill-hog"
  local bin_dir="${TARGET_HOME}/.local/bin"
  local script="${bin_dir}/kill-hog"

  mkdir -p "$bin_dir"
  cat > "$script" <<'KILLHOG'
#!/usr/bin/env bash
# Mata o processo com maior uso de CPU, protegendo o essencial.
# Instalado por setup-oom-protection.sh
set -euo pipefail

PROTEGIDOS='systemd|Xorg|Xwayland|gnome-shell|gnome-session|sshd|tailscaled|dbus-daemon|kwin|plasmashell|kill-hog'

read -r PID PCPU CMD < <(
  ps -eo pid,pcpu,comm --sort=-pcpu --no-headers \
    | grep -v -E "$PROTEGIDOS" \
    | head -1
) || true

if [[ -z "${PID:-}" ]]; then
  notify-send "kill-hog" "Nenhum candidato encontrado." 2>/dev/null || true
  exit 0
fi

kill -9 "$PID" 2>/dev/null || true
notify-send "kill-hog" "Morto: ${CMD} (PID ${PID}, ${PCPU}% CPU)" 2>/dev/null \
  || echo "Morto: ${CMD} (PID ${PID}, ${PCPU}% CPU)"
KILLHOG

  chmod +x "$script"
  chown -R "$TARGET_USER:$TARGET_USER" "$bin_dir"
  ok "$script instalado"

  register_gnome_shortcut "$script"
}

# Registra Ctrl+Alt+K no GNOME. Precisa da sessão do usuário ativa;
# em post-install "puro" (sem sessão gráfica) isso é pulado.
register_gnome_shortcut() {
  local cmd="$1"
  local uid; uid=$(id -u "$TARGET_USER")
  local bus="unix:path=/run/user/${uid}/bus"

  if [[ ! -S "/run/user/${uid}/bus" ]]; then
    warn "Sessão gráfica de $TARGET_USER não está ativa."
    warn "Atalho não registrado. Rode isto depois, como $TARGET_USER:"
    warn "  $0 --shortcut-only"
    return 0
  fi

  if ! command -v gsettings &>/dev/null; then
    warn "gsettings ausente — registre o atalho manualmente."
    return 0
  fi

  local base="org.gnome.settings-daemon.plugins.media-keys"
  local path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kill-hog/"

  run_as_user() {
    sudo -u "$TARGET_USER" DBUS_SESSION_BUS_ADDRESS="$bus" "$@"
  }

  local atuais
  atuais=$(run_as_user gsettings get "$base" custom-keybindings 2>/dev/null || echo "@as []")

  if [[ "$atuais" != *"$path"* ]]; then
    local novo
    if [[ "$atuais" == "@as []" || "$atuais" == "[]" ]]; then
      novo="['$path']"
    else
      novo="${atuais%]}, '$path']"
    fi
    run_as_user gsettings set "$base" custom-keybindings "$novo"
  fi

  run_as_user gsettings set "${base}.custom-keybinding:${path}" name 'kill-hog'
  run_as_user gsettings set "${base}.custom-keybinding:${path}" command "$cmd"
  run_as_user gsettings set "${base}.custom-keybinding:${path}" binding '<Control><Alt>k'

  ok "Atalho Ctrl+Alt+K registrado"
}

# ---------------------------------------------------------------------------
# Verificação final
# ---------------------------------------------------------------------------

verificar() {
  log "Verificação"

  systemctl is-active --quiet earlyoom \
    && ok "earlyoom rodando" \
    || warn "earlyoom não está rodando"

  if command -v zramctl &>/dev/null && [[ -n "$(zramctl --noheadings 2>/dev/null)" ]]; then
    ok "zram ativo: $(zramctl --noheadings --output NAME,DISKSIZE,ALGORITHM | tr -s ' ')"
  else
    warn "zram não detectado (pode exigir reboot)"
  fi

  [[ "$(sysctl -n kernel.sysrq)" == "1" ]] \
    && ok "SysRq habilitado" \
    || warn "SysRq não habilitado"

  local unit="pm2-${TARGET_USER}"
  if systemctl cat "${unit}.service" &>/dev/null; then
    local mem; mem=$(systemctl show "$unit" -p MemoryMax --value)
    [[ "$mem" != "infinity" ]] \
      && ok "PM2 com MemoryMax=$mem" \
      || warn "PM2 sem limite de memória"
  fi

  echo
  log "Pronto."
  echo "  Acompanhar earlyoom : journalctl -u earlyoom -f"
  echo "  Uso de memória      : free -h && zramctl"
  echo "  Emergência (RAM)    : Alt+PrtScn+F"
  echo "  Emergência (CPU)    : Ctrl+Alt+K"
  echo "  Se tudo travar      : Ctrl+Alt+F3 -> pm2 stop all"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

# Modo só-atalho, para quando o post-install rodou sem sessão gráfica.
if [[ "${1:-}" == "--shortcut-only" ]]; then
  register_gnome_shortcut "${TARGET_HOME}/.local/bin/kill-hog"
  exit 0
fi

apt-get update -qq

$ENABLE_EARLYOOM      && setup_earlyoom
$ENABLE_ZRAM          && setup_zram
$ENABLE_SYSRQ         && setup_sysrq
$ENABLE_DESKTOP_PRIO  && setup_desktop_priority
$ENABLE_PM2_LIMITS    && setup_pm2_limits
$ENABLE_KILLHOG       && setup_killhog

echo
verificar
