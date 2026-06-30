#!/bin/bash
#
## Execute diretamente usando (trocando o nome do usuário, obviamente):
## sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/williampilger/utilidades_gerais/refs/heads/master/LinuxScripts/take-screenshot-via-ssh.sh)" _ aluno /tmp/shot.png
#
# print_sessao_aluno.sh
# Tira um print da sessão gráfica de um usuário fisicamente logado (X11 ou Wayland).
# Uso:
#   sudo ./print_sessao_aluno.sh <usuario> [destino.png]
#
# Exemplos:
#   sudo ./print_sessao_aluno.sh aluno
#   sudo ./print_sessao_aluno.sh aluno /tmp/aluno_micro08.png
#
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Erro: rode como root (sudo)." >&2
    exit 1
fi

USUARIO="${1:-}"
if [[ -z "$USUARIO" ]]; then
    echo "Uso: $0 <usuario> [destino.png]" >&2
    exit 1
fi

DESTINO="${2:-/tmp/print_${USUARIO}_$(date +%Y%m%d_%H%M%S).png}"

# 1. Confirma que o usuário existe e tem sessão gráfica ativa
if ! id "$USUARIO" >/dev/null 2>&1; then
    echo "Erro: usuário '$USUARIO' não existe." >&2
    exit 1
fi

UID_USR=$(id -u "$USUARIO")

# Pega um processo de sessão gráfica do usuário (gnome-shell cobre GNOME/Zorin;
# se usar outro DE, ajuste a lista de candidatos abaixo)
PID=""
for CANDIDATO in gnome-shell cinnamon xfce4-session plasmashell; do
    PID=$(pgrep -u "$USUARIO" -n "$CANDIDATO" 2>/dev/null || true)
    [[ -n "$PID" ]] && break
done

if [[ -z "$PID" ]]; then
    echo "Erro: nenhuma sessão gráfica ativa encontrada para '$USUARIO'." >&2
    echo "Verifique com: loginctl list-sessions" >&2
    exit 1
fi

# 2. Extrai variáveis de ambiente reais do processo da sessão
ENVIRON=$(cat "/proc/$PID/environ" | tr '\0' '\n')

DISPLAY_VAR=$(echo "$ENVIRON" | grep '^DISPLAY=' | cut -d= -f2- || true)
XAUTHORITY_VAR=$(echo "$ENVIRON" | grep '^XAUTHORITY=' | cut -d= -f2- || true)
DBUS_VAR=$(echo "$ENVIRON" | grep '^DBUS_SESSION_BUS_ADDRESS=' | cut -d= -f2- || true)

# Fallback do DBUS, caso não esteja no environ do processo
if [[ -z "$DBUS_VAR" ]]; then
    DBUS_VAR="unix:path=/run/user/${UID_USR}/bus"
fi

echo "Usuário: $USUARIO (UID $UID_USR)"
echo "PID sessão: $PID"
echo "DISPLAY: ${DISPLAY_VAR:-<não encontrado>}"
echo "XAUTHORITY: ${XAUTHORITY_VAR:-<não encontrado>}"
echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_VAR"
echo

capturar_via_gnome_screenshot() {
    [[ -z "$DISPLAY_VAR" || -z "$XAUTHORITY_VAR" ]] && return 1
    sudo -u "$USUARIO" \
        DISPLAY="$DISPLAY_VAR" \
        XAUTHORITY="$XAUTHORITY_VAR" \
        DBUS_SESSION_BUS_ADDRESS="$DBUS_VAR" \
        gnome-screenshot -f "$DESTINO" 2>/dev/null
}

capturar_via_dbus() {
    sudo -u "$USUARIO" \
        DBUS_SESSION_BUS_ADDRESS="$DBUS_VAR" \
        gdbus call --session \
        --dest org.gnome.Shell.Screenshot \
        --object-path /org/gnome/Shell/Screenshot \
        --method org.gnome.Shell.Screenshot.Screenshot \
        true false "$DESTINO" >/dev/null 2>&1
}

# 3. Tenta gnome-screenshot (X11 ou Wayland com XWayland funcionando)
echo "Tentando captura via gnome-screenshot..."
if capturar_via_gnome_screenshot && [[ -f "$DESTINO" ]]; then
    echo "OK: captura feita via gnome-screenshot."
else
    echo "Falhou ou indisponível. Tentando via D-Bus (org.gnome.Shell.Screenshot)..."
    if capturar_via_dbus && [[ -f "$DESTINO" ]]; then
        echo "OK: captura feita via D-Bus."
    else
        echo "Erro: não foi possível capturar a tela por nenhum dos métodos." >&2
        exit 1
    fi
fi

chown "$USUARIO":"$USUARIO" "$DESTINO" 2>/dev/null || true
echo "Print salvo em: $DESTINO"
chafa $DESTINO
