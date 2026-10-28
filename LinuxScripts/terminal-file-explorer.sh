#!/bin/bash
#
## Execute diretamente usando:
## bash <(curl -fsSL https://raw.githubusercontent.com/williampilger/utilidades_gerais/refs/heads/master/LinuxScripts/terminal-file-explorer.sh)
#
# terminal-file-explorer.sh
# Explorador de arquivos navegável pelo teclado, direto no terminal, para o PC local
# ou para outro PC via SSH (hosts Linux/Unix e Windows com OpenSSH Server).
#
# Uso:
#   ./terminal-file-explorer.sh                       # menu inicial: local ou SSH
#   ./terminal-file-explorer.sh local [caminho]       # navega no PC local
#   ./terminal-file-explorer.sh <destino> [caminho]   # navega em um host via SSH
#   ./terminal-file-explorer.sh --deps                # verifica/instala dependências
#
#   <destino> pode ser um Host do ~/.ssh/config, um host cadastrado no multi-ssh
#   (~/.config/multi-ssh/hosts.json) ou usuario@host[:porta].
#
# Recursos:
#   - navegação com as setas (pressione ? dentro do explorador para ver todas as teclas)
#   - abrir arquivos de texto (visualizar/editar) e ver imagens no próprio terminal, no
#     melhor modo suportado: protocolo kitty (kitty/ghostty/wezterm/konsole), iTerm2,
#     sixel ou blocos coloridos
#   - renomear, copiar, recortar/colar, apagar e criar pastas
#   - SSH: download/upload de arquivos e pastas (sftp) e edição de arquivos remotos
#   - a conexão SSH é aberta uma única vez (ControlMaster): a senha é pedida só no início
#
# Hosts Windows: requer OpenSSH Server; os comandos são executados via powershell.exe
# (funciona tanto com cmd quanto com PowerShell como shell padrão do SSH).
#
# Dependências: bash 4+ e coreutils. Os demais pacotes (ssh, file, less, chafa,
# imagemagick, sshpass, ...) são verificados e o script oferece instalá-los.
#
# Variáveis opcionais:
#   TFE_IMG_VIEWER   comando próprio para exibir imagens (recebe o arquivo como argumento)
#   VISUAL / EDITOR  editor usado para editar arquivos (padrão: nano, vim ou vi)
#

if [[ -z ${BASH_VERSINFO[0]} || ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo "Erro: requer bash 4 ou superior." >&2
    exit 1
fi

set -o pipefail
shopt -s extglob

SCRIPT_NAME=${0##*/}
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/terminal-file-explorer"
MULTISSH_HOSTS="$HOME/.config/multi-ssh/hosts.json"
START_DIR=$PWD
LOCAL_HOSTNAME=$(hostname 2>/dev/null || uname -n)

# ── Estado ────────────────────────────────────────────────────────────────────

MODE=""                # local | unix | win
HOST_LABEL=""
TARGET_HOST=""
TARGET_OPTS=()
SSH_BASE=()
REMOTE_HOME=""
CUR=""

E_NAME=() E_TYPE=() E_DIR=() E_SIZE=() E_MTIME=()
CURSOR=0 SCROLL=0 LIST_H=10
declare -A MARKED=()
CLIP_OP="" CLIP_ITEMS=()
SHOW_HIDDEN=0
FILTER=""
STATUS=""
ROWS=24 COLS=80
LAST_DL_DIR="$HOME/Downloads"
LAST_UP_DIR=$START_DIR
TUI_ON=0
IN_EXT=0
PKG_MGR=""
APT_UPDATED=0

TMPD=$(mktemp -d "${TMPDIR:-/tmp}/tfe.XXXXXX") || { echo "Erro: não foi possível criar diretório temporário." >&2; exit 1; }
chmod 700 "$TMPD"

C_RST=$'\e[0m'   C_B=$'\e[1m'      C_DIM=$'\e[2m'    C_REV=$'\e[7m'
C_DIR=$'\e[1;34m' C_LNK=$'\e[36m'  C_MRK=$'\e[1;32m' C_TTL=$'\e[1;36m'
C_PATH=$'\e[1;33m' C_ERR=$'\e[1;31m' C_OK=$'\e[1;32m' C_SEP=$'\e[90m' C_WRN=$'\e[33m'

if [[ ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} =~ [Uu][Tt][Ff]-?8 ]]; then
    PTR="❯" CHK="✓" HR="─" ELL="…" I_DIR="📁" I_FILE="📄" I_LINK="🔗" I_PC="💻" I_NET="🌐" I_ADD="➕"
else
    PTR=">" CHK="*" HR="-" ELL="~" I_DIR="d " I_FILE="  " I_LINK="l " I_PC="" I_NET="" I_ADD="+"
fi

IMG_EXT_RE='\.(png|jpe?g|gif|bmp|webp|tiff?|ico|svg|heic|heif|avif|ppm|pgm|pbm|tga|xpm|jxl)$'

# ── Utilitários ───────────────────────────────────────────────────────────────

have() { command -v "$1" >/dev/null 2>&1; }

# Aspas simples para sh
sq() { local s=${1//\'/\'\\\'\'}; printf "'%s'" "$s"; }

# Aspas simples para PowerShell (inclui as aspas "tipográficas", que o PowerShell também aceita)
psq() {
    local s=${1//\'/\'\'}
    s=${s//‘/‘‘}; s=${s//’/’’}; s=${s//‚/‚‚}; s=${s//‛/‛‛}
    printf "'%s'" "$s"
}

# Escape para argumentos do sftp em modo batch (barra antes de todo caractere especial)
sftpq() {
    local s=$1 o="" i c
    for ((i = 0; i < ${#s}; i++)); do
        c=${s:i:1}
        if [[ $c == [a-zA-Z0-9/._-] ]]; then o+=$c; else o+="\\$c"; fi
    done
    printf '%s' "$o"
}

fmt_size() {
    local s=${1:-0} u d x
    if (( s < 1024 )); then REPLY="$s B"; return; fi
    if   (( s >= 1099511627776 )); then u=TB d=1099511627776
    elif (( s >= 1073741824 ));    then u=GB d=1073741824
    elif (( s >= 1048576 ));       then u=MB d=1048576
    else                                u=KB d=1024; fi
    x=$(( (s * 10 + d / 2) / d ))
    REPLY="$((x / 10)).$((x % 10)) $u"
}

b64() { base64 | tr -d '\n'; }

# Converte texto para UTF-16LE em base64 (para powershell -EncodedCommand)
utf16le_b64() {
    if have iconv; then
        printf '%s' "$1" | iconv -f UTF-8 -t UTF-16LE | b64
        return
    fi
    local LC_ALL=C.UTF-8 s=$1 out="" i c cp hi lo e
    for ((i = 0; i < ${#s}; i++)); do
        c=${s:i:1}
        printf -v cp '%d' "'$c"
        if (( cp > 0xFFFF )); then
            (( cp -= 0x10000, hi = 0xD800 + (cp >> 10), lo = 0xDC00 + (cp & 0x3FF) ))
            printf -v e '\\x%02x\\x%02x\\x%02x\\x%02x' $((hi & 255)) $((hi >> 8)) $((lo & 255)) $((lo >> 8))
        else
            printf -v e '\\x%02x\\x%02x' $((cp & 255)) $((cp >> 8))
        fi
        out+=$e
    done
    printf '%b' "$out" | b64
}

# ── Terminal ──────────────────────────────────────────────────────────────────

term_size() {
    local s
    s=$(stty size </dev/tty 2>/dev/null) && read -r ROWS COLS <<<"$s"
    [[ $ROWS =~ ^[0-9]+$ ]] && (( ROWS > 0 )) || ROWS=24
    [[ $COLS =~ ^[0-9]+$ ]] && (( COLS > 0 )) || COLS=80
}

tui_enter() {
    printf '\e[?1049h\e[?7l\e[?25l\e[H\e[2J'
    stty -echo 2>/dev/null
    TUI_ON=1
}

tui_leave() {
    printf '\e[0m\e[?25h\e[?7h\e[?1049l'
    stty echo 2>/dev/null
    TUI_ON=0
}

# Executa um programa externo fora da tela do explorador
ext_run() {
    local rc
    tui_leave
    IN_EXT=1
    "$@"
    rc=$?
    IN_EXT=0
    tui_enter
    return $rc
}

drain_input() { while IFS= read -rsn1 -t 0.01 _; do :; done; }

pause_key() {
    printf '\n%sPressione qualquer tecla para continuar...%s' "$C_DIM" "$C_RST"
    drain_input
    IFS= read -rsn1 _
    drain_input
    echo
}

on_int() {
    (( IN_EXT )) && return
    exit 130
}

cleanup() {
    (( TUI_ON )) && tui_leave
    if [[ -S $TMPD/ctl ]]; then
        ssh "${SSH_BASE[@]}" -O exit "$TARGET_HOST" >/dev/null 2>&1
    fi
    rm -rf -- "$TMPD"
}

trap cleanup EXIT
trap on_int INT
trap 'exit 143' TERM HUP

read_key() {
    local k c rc r s
    KEY=""
    while :; do
        IFS= read -rsn1 -t 1 k
        rc=$?
        (( rc == 0 )) && break
        if (( rc > 128 )); then
            # sem tecla: verifica se o terminal foi redimensionado
            r=$ROWS s=$COLS
            term_size
            if (( r != ROWS || s != COLS )); then KEY=RESIZE; return; fi
            continue
        fi
        KEY=EOF
        return
    done
    if [[ $k == $'\e' ]]; then
        if IFS= read -rsn1 -t 0.05 c; then
            k+=$c
            if [[ $c == '[' || $c == O ]]; then
                while IFS= read -rsn1 -t 0.05 c; do
                    k+=$c
                    [[ $c == [A-Za-z~] ]] && break
                done
            fi
        fi
    fi
    case $k in
        $'\e[A'|$'\eOA') KEY=UP ;;
        $'\e[B'|$'\eOB') KEY=DOWN ;;
        $'\e[C'|$'\eOC') KEY=RIGHT ;;
        $'\e[D'|$'\eOD') KEY=LEFT ;;
        $'\e[5~') KEY=PGUP ;;
        $'\e[6~') KEY=PGDN ;;
        $'\e[H'|$'\e[1~'|$'\eOH'|$'\e[7~') KEY=HOME ;;
        $'\e[F'|$'\e[4~'|$'\eOF'|$'\e[8~') KEY=END ;;
        $'\e[3~') KEY=DEL ;;
        $'\eOP'|$'\e[11~') KEY=F1 ;;
        $'\eOQ'|$'\e[12~') KEY=F2 ;;
        $'\e[15~') KEY=F5 ;;
        $'\e[18~') KEY=F7 ;;
        $'\e[19~') KEY=F8 ;;
        $'\e') KEY=ESC ;;
        $'\e'*) KEY=UNKNOWN ;;
        ''|$'\n'|$'\r') KEY=ENTER ;;
        $'\x7f'|$'\b') KEY=BACKSPACE ;;
        ' ') KEY=SPACE ;;
        $'\t') KEY=TAB ;;
        $'\x12') KEY=CTRL_R ;;
        $'\x0c') KEY=CTRL_L ;;
        *) KEY=$k ;;
    esac
}

# Escreve uma mensagem na última linha (sobre a linha de dicas)
bottom_msg() {
    printf '\e[%d;1H\e[0m\e[K%s' "$ROWS" "$1"
}

# Mostra uma mensagem na linha de status imediatamente (operações demoradas)
status_now() {
    printf '\e[%d;1H\e[0m\e[K %s' "$((ROWS - 1))" "$1"
}

# Lê uma linha (com edição e Tab para completar caminhos locais). Retorna 1 se vazio.
prompt() {
    local label=$1 init=${2-} rc
    printf '\e[%d;1H\e[0m\e[K\e[?25h\e[?7h' "$ROWS"
    stty echo 2>/dev/null
    IN_EXT=1
    IFS= read -e -r -p $'\001'"${C_PATH}"$'\002'"$label"$'\001'"${C_RST}"$'\002' -i "$init" REPLY
    rc=$?
    IN_EXT=0
    stty -echo 2>/dev/null
    printf '\e[?25l\e[?7l'
    (( rc == 0 )) && [[ -n $REPLY ]]
}

# Pergunta sim/não com uma tecla. $2 = padrão para Enter (s|n)
confirm() {
    bottom_msg "${C_PATH}$1${C_RST} "
    drain_input
    read_key
    case $KEY in
        s|S|y|Y) return 0 ;;
        ENTER) [[ ${2:-n} == s ]] ;;
        *) return 1 ;;
    esac
}

# Mostra várias linhas em tela cheia e espera uma tecla
show_screen() {
    local title=$1 line
    shift
    printf '\e[H\e[2J\e[?7h %s%s%s\n\n' "$C_TTL" "$title" "$C_RST"
    for line in "$@"; do printf ' %s\n' "$line"; done
    pause_key
    printf '\e[?7l'
}

# ── Dependências ──────────────────────────────────────────────────────────────

detect_pkg_mgr() {
    [[ -n $PKG_MGR ]] && return 0
    local m
    for m in apt-get dnf yum pacman zypper apk brew; do
        if have "$m"; then PKG_MGR=${m%-get}; return 0; fi
    done
    return 1
}

# Nome do pacote que fornece o comando, no gerenciador detectado
pkg_for() {
    case $1:$PKG_MGR in
        ssh:apt|sftp:apt|ssh:apk|sftp:apk)                         echo openssh-client ;;
        ssh:dnf|sftp:dnf|ssh:yum|sftp:yum|ssh:zypper|sftp:zypper)  echo openssh-clients ;;
        ssh:*|sftp:*)                                              echo openssh ;;
        magick:dnf|magick:yum|magick:zypper)                       echo ImageMagick ;;
        magick:*)                                                  echo imagemagick ;;
        bat:*)                                                     echo bat ;;
        python3:pacman|python3:brew)                               echo python ;;
        *)                                                         echo "$1" ;;
    esac
}

as_root() {
    if (( EUID == 0 )) || [[ $PKG_MGR == brew ]]; then
        "$@"
    elif have sudo; then
        sudo "$@"
    else
        echo "(sem sudo: será pedida a senha do root)"
        su root -c "$(printf '%q ' "$@")"
    fi
}

install_pkgs() {
    local -a pkgs=("$@") cmd
    detect_pkg_mgr || { echo "${C_ERR}Nenhum gerenciador de pacotes suportado encontrado (apt, dnf, yum, pacman, zypper, apk, brew).${C_RST}"; return 1; }
    case $PKG_MGR in
        apt)
            if (( ! APT_UPDATED )); then
                as_root apt-get update && APT_UPDATED=1
            fi
            cmd=(env DEBIAN_FRONTEND=noninteractive apt-get install -y) ;;
        dnf|yum) cmd=("$PKG_MGR" install -y) ;;
        pacman)  cmd=(pacman -S --needed --noconfirm) ;;
        zypper)  cmd=(zypper --non-interactive install) ;;
        apk)     cmd=(apk add) ;;
        brew)    cmd=(brew install) ;;
    esac
    echo "${C_B}Instalando: ${pkgs[*]}${C_RST}"
    as_root "${cmd[@]}" "${pkgs[@]}" && return 0
    # se o lote falhar (ex.: um pacote inexistente no repositório), tenta um a um
    local p rc=0
    if (( ${#pkgs[@]} > 1 )); then
        echo "${C_WRN}Falha no lote; tentando instalar um a um...${C_RST}"
        for p in "${pkgs[@]}"; do
            as_root "${cmd[@]}" "$p" || { echo "${C_ERR}✗ não foi possível instalar: $p${C_RST}"; rc=1; }
        done
    else
        rc=1
    fi
    return $rc
}

# Oferece instalar um comando no momento em que ele é necessário.
# $1 = comando, $2 = para que serve. Retorna 0 se o comando estiver disponível ao final.
ensure_cmd() {
    local cmd=$1 why=$2 was_tui=$TUI_ON
    have "$cmd" && return 0
    [[ $cmd == bat ]] && have batcat && return 0
    [[ $cmd == magick ]] && have convert && return 0
    detect_pkg_mgr || return 1
    local pkg; pkg=$(pkg_for "$cmd")
    if (( was_tui )); then
        confirm "'$cmd' não está instalado ($why). Instalar o pacote '$pkg' agora? [S/n]" s || return 1
        tui_leave
    else
        printf '%s' "'$cmd' não está instalado ($why). Instalar o pacote '$pkg' agora? [S/n] "
        local a; IFS= read -r a; [[ -z $a || $a == [sSyY]* ]] || return 1
    fi
    install_pkgs "$pkg"
    hash -r
    if (( was_tui )); then
        have "$cmd" || pause_key
        tui_enter
    fi
    have "$cmd" || { [[ $cmd == bat ]] && have batcat; }
}

# Verificação geral (no início e com --deps)
deps_check() {
    local force=${1:-0} c pkg
    [[ $force == 0 && -e $CONF_DIR/no-deps-prompt ]] && return 0
    # comando | descrição
    local -a list=(
        "file|detectar o tipo dos arquivos (texto, imagem, binário)"
        "less|visualizar arquivos de texto"
        "ssh|acessar outros PCs via SSH"
        "sftp|download/upload de arquivos via SSH"
        "chafa|exibir imagens no terminal (detecta o melhor modo do terminal)"
        "magick|converter/exibir imagens (ImageMagick)"
        "nano|editar arquivos de texto"
        "sshpass|usar as senhas cadastradas no multi-ssh"
        "bat|visualizar texto com realce de sintaxe (opcional)"
    )
    local -a miss_cmd=() miss_desc=()
    for c in "${list[@]}"; do
        local cmd=${c%%|*}
        case $cmd in
            magick) have magick || have convert && continue ;;
            bat)    have bat || have batcat && continue ;;
            nano)   [[ -n ${VISUAL:-${EDITOR:-}} ]] || have vim || have vi && continue ;;
            sshpass) [[ -f $MULTISSH_HOSTS ]] || continue ;;
        esac
        have "$cmd" && continue
        miss_cmd+=("$cmd"); miss_desc+=("${c#*|}")
    done
    if (( ${#miss_cmd[@]} == 0 )); then
        (( force )) && echo "${C_OK}✓ Todas as dependências estão instaladas.${C_RST}"
        return 0
    fi
    if ! detect_pkg_mgr; then
        echo "${C_WRN}Pacotes ausentes: ${miss_cmd[*]} (nenhum gerenciador de pacotes suportado encontrado).${C_RST}"
        return 0
    fi
    echo
    echo "${C_TTL}Terminal File Explorer${C_RST} — alguns pacotes úteis não estão instalados:"
    echo
    local i seen=" "
    local -a pkgs=()
    for i in "${!miss_cmd[@]}"; do
        pkg=$(pkg_for "${miss_cmd[i]}")
        printf '  %s%-10s%s %-18s %s\n' "$C_B" "${miss_cmd[i]}" "$C_RST" "(pacote $pkg)" "${miss_desc[i]}"
        [[ $seen == *" $pkg "* ]] || { pkgs+=("$pkg"); seen+="$pkg "; }
    done
    echo
    printf 'Instalar via %s? [S]im, todos / [e]scolher / [n]ão / nunca [p]erguntar novamente: ' "$PKG_MGR"
    local a; IFS= read -r a
    case $a in
        ''|[sSyY]*) install_pkgs "${pkgs[@]}" ;;
        [eE]*)
            local -a chosen=()
            for pkg in "${pkgs[@]}"; do
                printf '  Instalar %s? [s/N] ' "$pkg"; IFS= read -r a
                [[ $a == [sSyY]* ]] && chosen+=("$pkg")
            done
            (( ${#chosen[@]} )) && install_pkgs "${chosen[@]}" ;;
        [pP]*)
            mkdir -p "$CONF_DIR" && : >"$CONF_DIR/no-deps-prompt"
            echo "Ok. Para verificar novamente use: $SCRIPT_NAME --deps" ;;
    esac
    hash -r
    echo
}

# ── Caminhos ──────────────────────────────────────────────────────────────────

p_join() {
    local d=$1 n=$2
    if [[ $MODE == win ]]; then
        if [[ -z $d ]]; then printf '%s\\' "$n"
        elif [[ $d == *\\ ]]; then printf '%s%s' "$d" "$n"
        else printf '%s\\%s' "$d" "$n"; fi
    else
        if [[ $d == */ ]]; then printf '%s%s' "$d" "$n"; else printf '%s/%s' "$d" "$n"; fi
    fi
}

p_parent() {
    local p=$1
    if [[ $MODE == win ]]; then
        if [[ -z $p || $p =~ ^[A-Za-z]:\\?$ ]]; then printf ''; return; fi
        p=${p%\\}; p=${p%\\*}
        [[ $p =~ ^[A-Za-z]:$ ]] && p+='\'
        printf '%s' "$p"
    else
        p=${p%/}
        [[ -z $p ]] && { printf /; return; }
        p=${p%/*}
        printf '%s' "${p:-/}"
    fi
}

p_base() {
    local p=$1
    if [[ $MODE == win ]]; then p=${p%\\}; printf '%s' "${p##*\\}"
    else p=${p%/}; printf '%s' "${p##*/}"; fi
}

has_parent() {
    if [[ $MODE == win ]]; then [[ -n $CUR ]]; else [[ $CUR != / ]]; fi
}

disp_path() {
    if [[ $MODE == win && -z $1 ]]; then printf 'Este computador (unidades)'; else printf '%s' "$1"; fi
}

# Normaliza um caminho digitado (relativo, ~, .., barras)
p_normalize() {
    local p=$1
    if [[ $MODE == win ]]; then
        p=${p//\//\\}
        [[ $p == '~' || $p == '~\'* ]] && p="$REMOTE_HOME${p:1}"
        [[ $p =~ ^[A-Za-z]: || $p == \\\\* ]] || p=$(p_join "$CUR" "$p")
        [[ $p =~ ^[A-Za-z]:$ ]] && p+='\'
        printf '%s' "$p"
        return
    fi
    local home=$HOME
    [[ $MODE == unix ]] && home=$REMOTE_HOME
    [[ $p == '~' || $p == '~/'* ]] && p="$home${p:1}"
    [[ $p == /* ]] || p="$CUR/$p"
    local -a parts=() out=()
    local part
    IFS=/ read -ra parts <<<"$p"
    for part in "${parts[@]}"; do
        case $part in
            ''|.) ;;
            ..) (( ${#out[@]} )) && unset 'out[-1]' ;;
            *) out+=("$part") ;;
        esac
    done
    local IFS=/
    printf '/%s' "${out[*]}"
}

# Caminho no formato do sftp (Windows: C:\x\y -> /C:/x/y)
rpath() {
    if [[ $MODE == win ]]; then local p=${1//\\//}; printf '/%s' "${p%/}"; else printf '%s' "$1"; fi
}

# ── Backend: execução de comandos ─────────────────────────────────────────────

# Executa um script sh (localmente ou no host Unix remoto)
run_sh() {
    local script=$1 cmd a
    shift
    if [[ $MODE == local ]]; then
        sh -c "$script" sh "$@"
    else
        cmd="sh -c $(sq "$script") sh"
        for a; do cmd+=" $(sq "$a")"; done
        ssh -n "${SSH_BASE[@]}" "$TARGET_HOST" "$cmd"
    fi
}

PS_PRE='[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;$o=[Console]::Out;$ProgressPreference="SilentlyContinue";$ErrorActionPreference="Stop";'
PS_PRE+='function J($d,$n){if($d -eq ""){return $n+"\"};if($d.EndsWith("\")){return $d+$n};return $d+"\"+$n};'
PS_PRE+='function M($e){$e.Exception.Message -replace "[\r\n]+"," "};'
PS_MAX=2500   # tamanho máximo do script por chamada (limite de linha de comando do cmd.exe)

# Executa um script PowerShell no host Windows
win_ps() {
    local enc
    enc=$(utf16le_b64 "$PS_PRE$1")
    ssh -n "${SSH_BASE[@]}" "$TARGET_HOST" "powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand $enc"
}

# Executa $1 (script que usa o array $I) para a lista de itens, em lotes
win_items() {
    local body=$1 arr="" it q rc=0
    shift
    for it; do
        q=$(psq "$it")
        if [[ -n $arr ]] && (( ${#PS_PRE} + ${#body} + ${#arr} + ${#q} + 12 > PS_MAX )); then
            win_ps "\$I=@($arr);$body" || rc=1
            arr=""
        fi
        arr+="${arr:+,}$q"
    done
    [[ -n $arr ]] && { win_ps "\$I=@($arr);$body" || rc=1; }
    return $rc
}

# ── Backend: scripts ──────────────────────────────────────────────────────────
# Formato da listagem: registros separados por NUL, campos por TAB:
#   TIPO  TAMANHO  MTIME  NOME
# TIPO = 2 letras: tipo do item e tipo do alvo (ff arquivo, dd pasta, ld link p/ pasta,
# lf link p/ arquivo); no Windows um 'h' no final indica item oculto.

SH_LIST='d=$1
[ -d "$d" ] || { echo "Não é um diretório: $d" >&2; exit 2; }
[ -r "$d" ] && [ -x "$d" ] || { echo "Permissão negada: $d" >&2; exit 3; }
if find "$d" -maxdepth 0 -printf "" >/dev/null 2>&1; then
    exec find "$d" -mindepth 1 -maxdepth 1 -printf "%y%Y\t%s\t%T@\t%f\0" 2>/dev/null
fi
cd -- "$d" || exit 3
for f in * .[!.]* ..?*; do
    [ -e "$f" ] || [ -L "$f" ] || continue
    if [ -d "$f" ]; then t2=d; else t2=f; fi
    if [ -L "$f" ]; then t=l; else t=$t2; fi
    s=$(stat -c %s -- "$f" 2>/dev/null || stat -f %z -- "$f" 2>/dev/null || echo 0)
    m=$(stat -c %Y -- "$f" 2>/dev/null || stat -f %m -- "$f" 2>/dev/null || echo 0)
    printf "%s%s\t%s\t%s\t%s\0" "$t" "$t2" "$s" "$m" "$f"
done'

SH_EXISTS='d=$1; shift
for n; do
    case $d in */) t=$d$n ;; *) t=$d/$n ;; esac
    if [ -e "$t" ] || [ -L "$t" ]; then printf "%s\0" "$n"; fi
done'

SH_PASTE='op=$1 dest=$2 pol=$3; shift 3
for s; do
    n=${s%/}; n=${n##*/}
    case $dest in */) t=$dest$n ;; *) t=$dest/$n ;; esac
    case "$dest/" in "$s"/*) printf "ERR\t%s: não é possível colar uma pasta dentro dela mesma\n" "$n"; continue ;; esac
    if [ -e "$t" ] || [ -L "$t" ]; then
        if [ "$s" = "$t" ] && [ "$op" = move ]; then printf "SKIP\t%s\n" "$n"; continue; fi
        case $pol in
            skip) printf "SKIP\t%s\n" "$n"; continue ;;
            overwrite)
                if [ "$s" = "$t" ]; then printf "ERR\t%s: origem e destino são o mesmo item\n" "$n"; continue; fi
                rm -rf -- "$t" || { printf "ERR\t%s: não foi possível sobrescrever\n" "$n"; continue; } ;;
            *)
                if [ -d "$s" ]; then st=$n; ex=; else
                    case $n in ?*.*) st=${n%.*}; ex=.${n##*.} ;; *) st=$n; ex= ;; esac
                fi
                i=1
                while :; do
                    case $dest in */) t="$dest$st (copia $i)$ex" ;; *) t="$dest/$st (copia $i)$ex" ;; esac
                    [ -e "$t" ] || [ -L "$t" ] || break
                    i=$((i + 1))
                done ;;
        esac
    fi
    if [ "$op" = copy ]; then e=$(cp -Rp -- "$s" "$t" 2>&1); else e=$(mv -- "$s" "$t" 2>&1); fi ||
        printf "ERR\t%s: %s\n" "$n" "$(printf %s "$e" | tr "\n" " ")"
done'

SH_DELETE='for p; do
    case $p in ""|/|/.|/..) printf "ERR\t%s: recusado\n" "$p"; continue ;; esac
    e=$(rm -rf -- "$p" 2>&1) || printf "ERR\t%s: %s\n" "${p##*/}" "$(printf %s "$e" | tr "\n" " ")"
done'

SH_RENAME='if [ -e "$2" ] || [ -L "$2" ]; then printf "ERR\tJá existe: %s\n" "${2##*/}"; exit 1; fi
e=$(mv -- "$1" "$2" 2>&1) || { printf "ERR\t%s\n" "$(printf %s "$e" | tr "\n" " ")"; exit 1; }'

SH_MKDIR='e=$(mkdir -- "$1" 2>&1) || { printf "ERR\t%s\n" "$(printf %s "$e" | tr "\n" " ")"; exit 1; }'

PS_LIST='if($p -eq ""){foreach($d in [IO.DriveInfo]::GetDrives()){$s=0;try{if($d.IsReady){$s=$d.TotalSize}}catch{};$o.Write("dd`t$s`t0`t"+$d.Name.TrimEnd("\")+"`0")};exit 0}
try{if(-not(Test-Path -LiteralPath $p -PathType Container)){throw "Não é um diretório: $p"};$it=Get-ChildItem -LiteralPath $p -Force}catch{[Console]::Error.Write((M $_));exit 1}
foreach($i in $it){$t=if($i.PSIsContainer){"dd"}else{"ff"};if($i.Attributes -band 1024){$t="l"+$t[1]};if($i.Attributes -band 2){$t+="h"};$s=if($i.PSIsContainer){0}else{$i.Length};$m=[int64]($i.LastWriteTimeUtc-[datetime]"1970-01-01").TotalSeconds;$o.Write("$t`t$s`t$m`t"+$i.Name+"`0")}'

PS_EXISTS='foreach($n in $I){if(Test-Path -LiteralPath (J $d $n)){$o.Write("$n`0")}}'

PS_PASTE='foreach($s in $I){$n=[IO.Path]::GetFileName($s.TrimEnd("\"));try{
$t=J $dst $n;$isd=Test-Path -LiteralPath $s -PathType Container
if($isd -and ($dst.TrimEnd("\")+"\").StartsWith($s.TrimEnd("\")+"\",[StringComparison]::OrdinalIgnoreCase)){throw "não é possível colar uma pasta dentro dela mesma"}
if(Test-Path -LiteralPath $t){
if($s -eq $t -and $op -eq "move"){$o.Write("SKIP`t$n`n");continue}
if($pol -eq "skip"){$o.Write("SKIP`t$n`n");continue}
if($pol -eq "overwrite"){if($s -eq $t){throw "origem e destino são o mesmo item"};Remove-Item -LiteralPath $t -Recurse -Force}
else{if($isd){$b=$n;$e=""}else{$b=[IO.Path]::GetFileNameWithoutExtension($n);$e=[IO.Path]::GetExtension($n)};$k=1;do{$t=J $dst "$b (copia $k)$e";$k++}while(Test-Path -LiteralPath $t)}}
if($op -eq "copy"){Copy-Item -LiteralPath $s -Destination $t -Recurse -Force}
elseif($isd){try{[IO.Directory]::Move($s,$t)}catch{Move-Item -LiteralPath $s -Destination $t -Force}}
else{try{[IO.File]::Move($s,$t)}catch{Move-Item -LiteralPath $s -Destination $t -Force}}
}catch{$o.Write("ERR`t${n}: "+(M $_)+"`n")}}'

PS_DELETE='foreach($p in $I){try{if($p.TrimEnd("\").Length -le 2){throw "recusado (raiz da unidade)"};Remove-Item -LiteralPath $p -Recurse -Force}catch{$o.Write("ERR`t"+[IO.Path]::GetFileName($p)+": "+(M $_)+"`n")}}'

PS_RENAME='try{if(Test-Path -LiteralPath $b){throw ("Já existe: "+[IO.Path]::GetFileName($b))};if(Test-Path -LiteralPath $a -PathType Container){[IO.Directory]::Move($a,$b)}else{[IO.File]::Move($a,$b)}}catch{$o.Write("ERR`t"+(M $_)+"`n");exit 1}'

PS_MKDIR='try{if(Test-Path -LiteralPath $p){throw "Já existe"};[void][IO.Directory]::CreateDirectory($p)}catch{$o.Write("ERR`t"+(M $_)+"`n");exit 1}'

# ── Backend: operações ────────────────────────────────────────────────────────

be_list() {
    if [[ $MODE == win ]]; then win_ps "\$p=$(psq "$1");$PS_LIST"; else run_sh "$SH_LIST" "$1"; fi
}

be_exists() {   # dir nomes...  -> nomes existentes (separados por NUL)
    local d=$1; shift
    if [[ $MODE == win ]]; then win_items "\$d=$(psq "$d");$PS_EXISTS" "$@"; else run_sh "$SH_EXISTS" "$d" "$@"; fi
}

be_paste() {    # copy|move destino política itens...
    local op=$1 dst=$2 pol=$3; shift 3
    if [[ $MODE == win ]]; then
        win_items "\$op=$(psq "$op");\$dst=$(psq "$dst");\$pol=$(psq "$pol");$PS_PASTE" "$@"
    else
        run_sh "$SH_PASTE" "$op" "$dst" "$pol" "$@"
    fi
}

be_delete() {
    if [[ $MODE == win ]]; then win_items "$PS_DELETE" "$@"; else run_sh "$SH_DELETE" "$@"; fi
}

be_rename() {
    if [[ $MODE == win ]]; then win_ps "\$a=$(psq "$1");\$b=$(psq "$2");$PS_RENAME"; else run_sh "$SH_RENAME" "$1" "$2"; fi
}

be_mkdir() {
    if [[ $MODE == win ]]; then win_ps "\$p=$(psq "$1");$PS_MKDIR"; else run_sh "$SH_MKDIR" "$1"; fi
}

# sftp em modo batch; os comandos vêm pela entrada padrão
sftp_batch() {
    sftp -q "${SSH_BASE[@]}" -b - "$TARGET_HOST"
}

sftp_get_quiet() {   # remoto local
    printf 'get %s %s\n' "$(sftpq "$(rpath "$1")")" "$(sftpq "$2")" | sftp_batch >/dev/null 2>"$TMPD/sftp.err"
}

sftp_put_quiet() {   # local remoto
    printf 'put %s %s\n' "$(sftpq "$2")" "$(sftpq "$(rpath "$1")")" | sftp_batch >/dev/null 2>"$TMPD/sftp.err"
}

# Mostra a saída de uma operação (linhas ERR/SKIP); retorna 1 se houve erro
report_ops() {
    local out=$1 okmsg=$2 line
    local -a errs=() skips=()
    while IFS= read -r line; do
        case $line in
            ERR$'\t'*)  errs+=("${line#*$'\t'}") ;;
            SKIP$'\t'*) skips+=("${line#*$'\t'}") ;;
            '') ;;
            *) [[ $line == '#< CLIXML'* || $line == '<Objs'* ]] || errs+=("$line") ;;
        esac
    done <<<"$out"
    if (( ${#errs[@]} )); then
        show_screen "Ocorreram ${#errs[@]} erro(s):" "${errs[@]/#/${C_ERR}✗${C_RST} }"
        STATUS="${C_ERR}✗ ${#errs[@]} erro(s)${C_RST}"
        return 1
    fi
    STATUS="${C_OK}✓ $okmsg${C_RST}"
    (( ${#skips[@]} )) && STATUS+="  ${C_DIM}(${#skips[@]} ignorado(s))${C_RST}"
    return 0
}

clean_err() {
    local line
    while IFS= read -r line; do
        line=${line%$'\r'}
        [[ -z $line || $line == '#< CLIXML'* || $line == '<Objs'* ]] && continue
        printf '%s' "$line"
        return
    done
}

# ── Listagem ──────────────────────────────────────────────────────────────────

# Carrega o diretório $1; $2 = nome a deixar selecionado
load_dir() {
    local path=$1 sel=${2-} rc
    be_list "$path" >"$TMPD/ls" 2>"$TMPD/ls.err"
    rc=$?
    if (( rc != 0 )) && [[ ! -s $TMPD/ls ]]; then
        local e; e=$(clean_err <"$TMPD/ls.err")
        STATUS="${C_ERR}✗ ${e:-Não foi possível abrir: $(disp_path "$path")}${C_RST}"
        return 1
    fi
    if [[ $path != "$CUR" ]]; then MARKED=(); SCROLL=0; CURSOR=0; fi
    CUR=$path
    [[ $MODE == local ]] && cd -- "$CUR" 2>/dev/null

    local -a recs=()
    local t s m n isdir
    while IFS=$'\t' read -r -d '' t s m n; do
        t=${t#$'\xef\xbb\xbf'}; n=${n%$'\r'}
        [[ -z $n || $n == . || $n == .. ]] && continue
        if (( ! SHOW_HIDDEN )); then
            if [[ $MODE == win ]]; then [[ $t == *h ]] && continue; else [[ $n == .* ]] && continue; fi
        fi
        [[ -n $FILTER && ${n,,} != *"${FILTER,,}"* ]] && continue
        [[ ${t:1:1} == d ]] && isdir=0 || isdir=1
        recs+=("$isdir"$'\t'"${t:0:2}"$'\t'"${s:-0}"$'\t'"${m%%.*}"$'\t'"$n")
    done <"$TMPD/ls"

    E_NAME=() E_TYPE=() E_DIR=() E_SIZE=() E_MTIME=()
    if has_parent; then
        E_NAME+=(".."); E_TYPE+=(up); E_DIR+=(1); E_SIZE+=(0); E_MTIME+=(0)
    fi
    if (( ${#recs[@]} )); then
        while IFS=$'\t' read -r -d '' isdir t s m n; do
            E_NAME+=("$n"); E_TYPE+=("$t"); E_DIR+=($(( isdir == 0 ))); E_SIZE+=("${s:-0}"); E_MTIME+=("${m:-0}")
        done < <(printf '%s\0' "${recs[@]}" | sort -z -t $'\t' -k1,1 -k5f)
    fi

    # remove marcações de itens que não existem mais
    local k i
    if (( ${#MARKED[@]} )); then
        local -A present=()
        for n in "${E_NAME[@]}"; do present[$n]=1; done
        for k in "${!MARKED[@]}"; do [[ -n ${present[$k]+x} ]] || unset 'MARKED[$k]'; done
    fi

    # cursor no item pedido; se ele sumiu (ex.: apagado), mantém a posição
    local oldc=$CURSOR
    CURSOR=0
    if [[ -n $sel ]]; then
        CURSOR=$oldc
        for i in "${!E_NAME[@]}"; do [[ ${E_NAME[i]} == "$sel" ]] && { CURSOR=$i; break; }; done
    fi
    return 0
}

reload() {
    local keep=""
    (( ${#E_NAME[@]} )) && keep=${E_NAME[CURSOR]}
    load_dir "$CUR" "$keep"
}

# ── Desenho da tela ───────────────────────────────────────────────────────────

render() {
    term_size
    LIST_H=$(( ROWS - 6 ))
    (( LIST_H < 1 )) && LIST_H=1
    local n=${#E_NAME[@]}
    (( CURSOR >= n )) && CURSOR=$(( n - 1 ))
    (( CURSOR < 0 )) && CURSOR=0
    (( CURSOR < SCROLL )) && SCROLL=$CURSOR
    (( CURSOR >= SCROLL + LIST_H )) && SCROLL=$(( CURSOR - LIST_H + 1 ))
    (( SCROLL < 0 )) && SCROLL=0

    local out="" hr p hdr
    printf -v hr '%*s' "$COLS" ''; hr=${hr// /$HR}

    case $MODE in
        local) hdr="$I_PC Local ($LOCAL_HOSTNAME)" ;;
        unix)  hdr="$I_NET $HOST_LABEL  [linux/unix]" ;;
        win)   hdr="$I_NET $HOST_LABEL  [windows]" ;;
    esac
    out+=" ${C_TTL}${hdr}${C_RST}"
    (( ${#MARKED[@]} )) && out+="  ${C_MRK}[${#MARKED[@]} marcado(s)]${C_RST}"
    if (( ${#CLIP_ITEMS[@]} )); then
        out+="  ${C_PATH}[transf.: ${#CLIP_ITEMS[@]} p/ $([[ $CLIP_OP == copy ]] && echo copiar || echo mover)]${C_RST}"
    fi
    (( SHOW_HIDDEN )) && out+="  ${C_DIM}[ocultos visíveis]${C_RST}"
    [[ -n $FILTER ]] && out+="  ${C_WRN}[filtro: $FILTER]${C_RST}"
    out+=$'\e[K\n'

    p=$(disp_path "$CUR")
    (( ${#p} > COLS - 2 )) && p="$ELL${p: -$((COLS - 3))}"
    out+=" ${C_PATH}${p}${C_RST}"$'\e[K\n'
    out+="${C_SEP}${hr}${C_RST}"$'\e[K\n'

    local meta_w=30 nw i row name t disp icon col mk ptr meta dt pad
    (( COLS < 60 )) && meta_w=0
    nw=$(( COLS - 8 - meta_w ))
    (( nw < 4 )) && nw=4

    if (( n == 0 )); then
        out+="   ${C_DIM}(vazio)${C_RST}"$'\e[K\n'
        row=1
    else
        row=0
    fi
    for (( i = SCROLL; i < SCROLL + LIST_H && i < n; i++, row++ )); do
        name=${E_NAME[i]} t=${E_TYPE[i]}
        if [[ $t == up ]]; then
            icon=$I_DIR disp=".. (subir)" col=$C_DIR
        elif (( E_DIR[i] )); then
            if [[ $t == l* ]]; then icon=$I_LINK col=$C_LNK; else icon=$I_DIR col=$C_DIR; fi
            disp="$name/"
        else
            if [[ $t == l* ]]; then icon=$I_LINK col=$C_LNK; else icon=$I_FILE col=""; fi
            disp=$name
        fi
        if [[ -n ${MARKED[$name]+x} ]]; then mk="$CHK " col=$C_MRK; else mk="  "; fi
        (( ${#disp} > nw )) && disp="${disp:0:nw-1}$ELL"
        printf -v pad '%*s' $(( nw - ${#disp} )) ''
        meta=""
        if (( meta_w )); then
            if (( E_DIR[i] )) && [[ $MODE != win || -n $CUR ]]; then
                REPLY=""
            else
                fmt_size "${E_SIZE[i]}"
            fi
            dt=""
            (( E_MTIME[i] > 0 )) && printf -v dt '%(%Y-%m-%d %H:%M)T' "${E_MTIME[i]}"
            [[ $t == up ]] && REPLY=""
            printf -v meta ' %10s  %-16s ' "$REPLY" "$dt"
        fi
        if (( i == CURSOR )); then
            ptr=$PTR
            out+="${C_REV}${col} ${ptr} ${mk}${icon} ${disp}${pad}${meta}${C_RST}"$'\e[K\n'
        else
            out+="${col}   ${mk}${icon} ${disp}${pad}${C_RST}${C_DIM}${meta}${C_RST}"$'\e[K\n'
        fi
    done
    for (( ; row < LIST_H; row++ )); do out+=$'\e[K\n'; done

    local pos=""
    (( n > LIST_H )) && pos=" $((CURSOR + 1))/$n "
    out+="${C_SEP}${hr:0:$(( COLS - ${#pos} ))}${C_RST}${C_DIM}${pos}${C_RST}"$'\e[K\n'
    out+=" ${STATUS}${C_RST}"$'\e[K\n'

    local hint
    if [[ $MODE == local ]]; then
        hint="Enter abrir  Espaço marcar  c/x/p copiar/recortar/colar  r renomear  Del apagar  m nova pasta  e editar  ? ajuda  q sair"
    else
        hint="Enter abrir  Espaço marcar  d baixar  u enviar  c/x/p copiar/recortar/colar  r renomear  Del apagar  ? ajuda  q sair"
    fi
    (( ${#hint} > COLS - 1 )) && hint="${hint:0:COLS-2}$ELL"
    out+=" ${C_DIM}${hint}${C_RST}"$'\e[K'

    printf '\e[H%s' "$out"
}

# ── Ações ─────────────────────────────────────────────────────────────────────

cur_is_item() {
    (( ${#E_NAME[@]} )) && [[ ${E_TYPE[CURSOR]} != up ]]
}

# Itens marcados ou, se nenhum, o item sob o cursor -> SEL_NAMES / SEL_PATHS
collect_sel() {
    SEL_NAMES=() SEL_PATHS=()
    local n
    if (( ${#MARKED[@]} )); then
        for n in "${!MARKED[@]}"; do SEL_NAMES+=("$n"); done
    elif cur_is_item; then
        SEL_NAMES=("${E_NAME[CURSOR]}")
    fi
    for n in "${SEL_NAMES[@]}"; do SEL_PATHS+=("$(p_join "$CUR" "$n")"); done
    (( ${#SEL_NAMES[@]} ))
}

sel_preview() {
    local s="${SEL_NAMES[*]:0:3}"
    (( ${#SEL_NAMES[@]} > 3 )) && s+=" ..."
    (( ${#s} > 50 )) && s="${s:0:49}$ELL"
    printf '%s' "$s"
}

require_remote() {
    [[ $MODE != local ]] && return 0
    STATUS="${C_WRN}Disponível apenas no modo SSH${C_RST}"
    return 1
}

act_up() {
    has_parent || return
    local base; base=$(p_base "$CUR")
    local old_filter=$FILTER
    FILTER=""
    load_dir "$(p_parent "$CUR")" "$base" || FILTER=$old_filter
}

act_open() {
    (( ${#E_NAME[@]} )) || return
    if [[ ${E_TYPE[CURSOR]} == up ]]; then act_up; return; fi
    local p; p=$(p_join "$CUR" "${E_NAME[CURSOR]}")
    if (( E_DIR[CURSOR] )); then
        local old_filter=$FILTER
        FILTER=""
        load_dir "$p" || FILTER=$old_filter
        return
    fi
    open_file "$CURSOR"
}

# Garante uma cópia local do arquivo (no modo SSH baixa para o temporário) -> REPLY
fetch_local() {
    local p=$1 size=${2:-0} d base
    if [[ $MODE == local ]]; then REPLY=$p; return 0; fi
    if (( size > 50 * 1024 * 1024 )); then
        fmt_size "$size"
        confirm "Arquivo grande ($REPLY). Baixar para abrir? [s/N]" || return 1
    fi
    base=$(p_base "$p")
    status_now "Baixando $base..."
    d=$(mktemp -d "$TMPD/v.XXXXXX")
    if ! sftp_get_quiet "$p" "$d/$base"; then
        STATUS="${C_ERR}✗ Falha ao baixar: $(clean_err <"$TMPD/sftp.err")${C_RST}"
        return 1
    fi
    REPLY="$d/$base"
}

# Classifica um arquivo local: image | text | binary  -> REPLY
file_kind() {
    local f=$1 name=${2,,} mime="" enc=""
    if have file; then
        mime=$(file -b --mime-type -- "$f" 2>/dev/null)
        case $mime in
            image/*) REPLY=image; return ;;
            text/*|inode/x-empty|application/json|application/xml|application/javascript|application/x-sh*|\
            application/x-*script*|application/x-php|application/x-perl|application/x-ruby|application/x-awk|\
            application/sql|application/x-ndjson|application/x-subrip|application/x-wine-extension-ini|message/*)
                REPLY=text; return ;;
        esac
        enc=$(file -b --mime-encoding -- "$f" 2>/dev/null)
        if [[ -n $enc && $enc != binary ]]; then REPLY=text; return; fi
        [[ -n $mime ]] && { REPLY=binary; return; }
    fi
    if [[ $name =~ $IMG_EXT_RE ]]; then REPLY=image; return; fi
    if [[ $(head -c 8192 -- "$f" | tr -dc '\000' | wc -c) -eq 0 ]]; then REPLY=text; else REPLY=binary; fi
}

open_file() {
    local idx=$1 p f kind
    p=$(p_join "$CUR" "${E_NAME[idx]}")
    fetch_local "$p" "${E_SIZE[idx]}" || return
    f=$REPLY
    file_kind "$f" "${E_NAME[idx]}"
    kind=$REPLY
    case $kind in
        image) image_loop "$idx" "$f" ;;
        text)  text_view "$f" "${E_NAME[idx]}" ;;
        *)
            local mime=""
            have file && mime=" ($(file -b -- "$f" 2>/dev/null | cut -c1-60))"
            bottom_msg "${C_PATH}Arquivo binário${mime}. [h] hexdump  [t] ver como texto  [o] app padrão  [outra] voltar${C_RST}"
            drain_input
            read_key
            case $KEY in
                h|H) hex_view "$f" ;;
                t|T) text_view "$f" "${E_NAME[idx]}" ;;
                o|O) xdg_open_file "$f" ;;
            esac ;;
    esac
}

text_view() {
    local f=$1 title=$2 bat=""
    if have batcat; then bat=batcat; elif have bat; then bat=bat; fi
    if [[ -n $bat ]]; then
        ext_run "$bat" --paging=always --style=header,numbers,grid --file-name "$title" -- "$f"
    elif have less || ensure_cmd less "visualizar arquivos de texto"; then
        ext_run less -R -M -- "$f"
    else
        ext_run more -- "$f"
    fi
}

hex_view() {
    local f=$1
    if have xxd; then ext_run sh -c 'xxd -- "$1" | less' sh "$f"
    else ext_run sh -c 'od -A x -t x1z -v -- "$1" | less' sh "$f"; fi
}

xdg_open_file() {
    local f=$1
    if [[ -z ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]] || ! have xdg-open; then
        STATUS="${C_WRN}Sem ambiente gráfico (ou xdg-open) disponível para abrir com app padrão${C_RST}"
        return
    fi
    setsid -f xdg-open "$f" >/dev/null 2>&1 </dev/null
    STATUS="${C_OK}✓ Aberto com o aplicativo padrão${C_RST}"
    [[ $MODE != local ]] && STATUS+="${C_DIM} (cópia temporária: removida ao sair)${C_RST}"
}

act_xdg() {
    cur_is_item || return
    local p; p=$(p_join "$CUR" "${E_NAME[CURSOR]}")
    if (( E_DIR[CURSOR] )) && [[ $MODE != local ]]; then
        STATUS="${C_WRN}Para pastas remotas use d (baixar)${C_RST}"; return
    fi
    fetch_local "$p" "${E_SIZE[CURSOR]}" || return
    xdg_open_file "$REPLY"
}

act_view() {
    cur_is_item || return
    (( E_DIR[CURSOR] )) && return
    local p; p=$(p_join "$CUR" "${E_NAME[CURSOR]}")
    fetch_local "$p" "${E_SIZE[CURSOR]}" || return
    text_view "$REPLY" "${E_NAME[CURSOR]}"
}

editor_cmd() {
    EDITOR_ARR=()
    local e=${VISUAL:-${EDITOR:-}}
    if [[ -n $e ]]; then read -ra EDITOR_ARR <<<"$e"; return 0; fi
    local c
    for c in nano vim vi; do have "$c" && { EDITOR_ARR=("$c"); return 0; }; done
    ensure_cmd nano "editar arquivos de texto" && { EDITOR_ARR=(nano); return 0; }
    return 1
}

act_edit() {
    cur_is_item || return
    if (( E_DIR[CURSOR] )); then STATUS="${C_WRN}Selecione um arquivo para editar${C_RST}"; return; fi
    editor_cmd || { STATUS="${C_ERR}✗ Nenhum editor disponível (defina \$EDITOR)${C_RST}"; return; }
    local name=${E_NAME[CURSOR]} p
    p=$(p_join "$CUR" "$name")
    if [[ $MODE == local ]]; then
        ext_run "${EDITOR_ARR[@]}" "$p"
        reload
        return
    fi
    fetch_local "$p" "${E_SIZE[CURSOR]}" || return
    local f=$REPLY before after
    before=$(cksum <"$f")
    ext_run "${EDITOR_ARR[@]}" "$f"
    after=$(cksum <"$f")
    if [[ $before == "$after" ]]; then STATUS="Sem alterações"; return; fi
    render
    if confirm "Enviar as alterações de '$name' para $HOST_LABEL? [S/n]" s; then
        status_now "Enviando $name..."
        if sftp_put_quiet "$p" "$f"; then
            STATUS="${C_OK}✓ Salvo em $HOST_LABEL: $name${C_RST}"
        else
            STATUS="${C_ERR}✗ Falha ao enviar: $(clean_err <"$TMPD/sftp.err") (cópia local: $f)${C_RST}"
        fi
        reload
    else
        STATUS="${C_WRN}Alterações não enviadas (cópia local: $f)${C_RST}"
    fi
}

act_info() {
    cur_is_item || return
    local i=$CURSOR p dt="" kind
    p=$(p_join "$CUR" "${E_NAME[i]}")
    (( E_MTIME[i] > 0 )) && printf -v dt '%(%Y-%m-%d %H:%M:%S)T' "${E_MTIME[i]}"
    case ${E_TYPE[i]} in dd) kind=pasta ;; ff) kind=arquivo ;; ld) kind="link p/ pasta" ;; l*) kind=link ;; *) kind=${E_TYPE[i]} ;; esac
    fmt_size "${E_SIZE[i]}"
    STATUS="$kind  ${C_B}$p${C_RST}  $( (( E_DIR[i] )) || printf '%s (%s bytes)  ' "$REPLY" "${E_SIZE[i]}")$dt"
}

act_mark() {
    cur_is_item || return
    local n=${E_NAME[CURSOR]}
    if [[ -n ${MARKED[$n]+x} ]]; then unset 'MARKED[$n]'; else MARKED[$n]=1; fi
}

act_mark_all() {
    local i all=1
    for i in "${!E_NAME[@]}"; do
        [[ ${E_TYPE[i]} == up ]] && continue
        [[ -n ${MARKED[${E_NAME[i]}]+x} ]] || { all=0; break; }
    done
    MARKED=()
    if (( ! all )); then
        for i in "${!E_NAME[@]}"; do [[ ${E_TYPE[i]} == up ]] || MARKED[${E_NAME[i]}]=1; done
    fi
}

act_rename() {
    cur_is_item || return
    local old=${E_NAME[CURSOR]} new out
    prompt "Novo nome: " "$old" || return
    new=$REPLY
    [[ $new == "$old" ]] && return
    if [[ $new == */* || $new == . || $new == .. ]] || { [[ $MODE == win ]] && [[ $new == *[\\:\*\?\"\<\>\|]* ]]; }; then
        STATUS="${C_ERR}✗ Nome inválido: $new${C_RST}"; return
    fi
    out=$(be_rename "$(p_join "$CUR" "$old")" "$(p_join "$CUR" "$new")" 2>&1)
    report_ops "$out" "Renomeado: $old → $new" || return
    [[ -n ${MARKED[$old]+x} ]] && { unset 'MARKED[$old]'; MARKED[$new]=1; }
    load_dir "$CUR" "$new"
}

act_mkdir() {
    [[ $MODE == win && -z $CUR ]] && return
    prompt "Nova pasta: " || return
    local name=$REPLY out
    if [[ $name == */* || $name == . || $name == .. ]]; then STATUS="${C_ERR}✗ Nome inválido${C_RST}"; return; fi
    out=$(be_mkdir "$(p_join "$CUR" "$name")" 2>&1)
    report_ops "$out" "Pasta criada: $name" || return
    load_dir "$CUR" "$name"
}

act_delete() {
    collect_sel || return
    [[ $MODE == win && -z $CUR ]] && return
    local n=${#SEL_NAMES[@]}
    confirm "${C_ERR}Apagar $n item(s): $(sel_preview)? Isto é IRREVERSÍVEL (pastas são apagadas inteiras). [s/N]" || {
        STATUS="Exclusão cancelada"; return; }
    status_now "Apagando..."
    local out; out=$(be_delete "${SEL_PATHS[@]}" 2>&1)
    report_ops "$out" "$n item(s) apagado(s)"
    MARKED=()
    reload
}

act_clip() {
    collect_sel || return
    [[ $MODE == win && -z $CUR ]] && return
    CLIP_OP=$1
    CLIP_ITEMS=("${SEL_PATHS[@]}")
    MARKED=()
    STATUS="${#CLIP_ITEMS[@]} item(s) na área de transferência para $([[ $CLIP_OP == copy ]] && echo copiar || echo mover) — vá até o destino e pressione p"
}

act_paste() {
    if (( ${#CLIP_ITEMS[@]} == 0 )); then
        STATUS="${C_WRN}Área de transferência vazia (use c para copiar ou x para recortar)${C_RST}"; return
    fi
    [[ $MODE == win && -z $CUR ]] && return
    local -a names=() conflicts=()
    local it pol=rename
    for it in "${CLIP_ITEMS[@]}"; do names+=("$(p_base "$it")"); done
    status_now "Verificando destino..."
    mapfile -t -d '' conflicts < <(be_exists "$CUR" "${names[@]}" 2>/dev/null)
    if (( ${#conflicts[@]} )); then
        bottom_msg "${C_PATH}${#conflicts[@]} item(s) já existe(m) aqui. [r]enomear cópia (padrão)  [s]obrescrever  [p]ular  [c]ancelar${C_RST} "
        drain_input
        read_key
        case $KEY in
            r|R|ENTER) pol=rename ;;
            s|S) pol=overwrite ;;
            p|P) pol=skip ;;
            *) STATUS="Colagem cancelada"; return ;;
        esac
    fi
    status_now "$([[ $CLIP_OP == copy ]] && echo Copiando || echo Movendo) ${#CLIP_ITEMS[@]} item(s)..."
    local out; out=$(be_paste "$CLIP_OP" "$CUR" "$pol" "${CLIP_ITEMS[@]}" 2>&1)
    report_ops "$out" "${#CLIP_ITEMS[@]} item(s) $([[ $CLIP_OP == copy ]] && echo "copiado(s)" || echo "movido(s)")"
    [[ $CLIP_OP == move ]] && CLIP_ITEMS=()
    reload
}

act_download() {
    require_remote || return
    collect_sel || return
    [[ -z $CUR ]] && return
    prompt "Baixar ${#SEL_NAMES[@]} item(s) para a pasta local (Tab completa): " "$LAST_DL_DIR" || return
    local dest=${REPLY%/}
    [[ $dest == '~' || $dest == '~/'* ]] && dest="$HOME${dest:1}"
    [[ $dest == /* ]] || dest="$START_DIR/$dest"
    if ! mkdir -p -- "$dest" 2>/dev/null; then STATUS="${C_ERR}✗ Não foi possível criar $dest${C_RST}"; return; fi
    LAST_DL_DIR=$dest

    local -a conflicts=()
    local n i
    for n in "${SEL_NAMES[@]}"; do [[ -e $dest/$n ]] && conflicts+=("$n"); done
    local skip=0
    if (( ${#conflicts[@]} )); then
        bottom_msg "${C_PATH}${#conflicts[@]} item(s) já existe(m) em $dest. [s]obrescrever  [p]ular existentes  [c]ancelar${C_RST} "
        drain_input
        read_key
        case $KEY in s|S) ;; p|P) skip=1 ;; *) STATUS="Download cancelado"; return ;; esac
    fi

    local batch="progress"$'\n' count=0
    for i in "${!SEL_NAMES[@]}"; do
        n=${SEL_NAMES[i]}
        (( skip )) && [[ -e $dest/$n ]] && continue
        batch+="-get -r $(sftpq "$(rpath "${SEL_PATHS[i]}")") $(sftpq "$dest/$n")"$'\n'
        (( count++ ))
    done
    (( count )) || { STATUS="Nada a baixar"; return; }

    tui_leave
    IN_EXT=1
    echo "${C_TTL}Baixando $count item(s) de $HOST_LABEL para $dest${C_RST}"
    echo
    printf '%s' "$batch" | sftp_batch 2> >(tee "$TMPD/sftp.err" >&2)
    IN_EXT=0
    sleep 0.1
    if [[ -s $TMPD/sftp.err ]]; then
        echo; echo "${C_WRN}⚠ Houve erros (veja acima).${C_RST}"
        STATUS="${C_WRN}⚠ Download concluído com erros${C_RST}"
    else
        echo; echo "${C_OK}✓ Concluído.${C_RST}"
        STATUS="${C_OK}✓ $count item(s) baixado(s) em $dest${C_RST}"
    fi
    pause_key
    tui_enter
    MARKED=()
}

act_upload() {
    require_remote || return
    [[ -z $CUR ]] && { STATUS="${C_WRN}Entre em uma unidade primeiro${C_RST}"; return; }
    prompt "Enviar arquivo/pasta local (Tab completa; curingas como *.jpg são aceitos): " "${LAST_UP_DIR%/}/" || return
    local in=$REPLY f
    [[ $in == '~' || $in == '~/'* ]] && in="$HOME${in:1}"
    [[ $in == /* ]] || in="$START_DIR/$in"
    in=${in%/}
    local -a files=()
    if [[ $in == *[\*\?\[]* ]]; then
        mapfile -t files < <(compgen -G "$in")
    elif [[ -e $in ]]; then
        files=("$in")
    fi
    (( ${#files[@]} )) || { STATUS="${C_ERR}✗ Não encontrado: $in${C_RST}"; return; }
    LAST_UP_DIR=${files[0]%/*}

    local -a names=() conflicts=()
    for f in "${files[@]}"; do names+=("${f##*/}"); done
    status_now "Verificando destino..."
    mapfile -t -d '' conflicts < <(be_exists "$CUR" "${names[@]}" 2>/dev/null)
    local skip=0
    if (( ${#conflicts[@]} )); then
        bottom_msg "${C_PATH}${#conflicts[@]} item(s) já existe(m) no host. [s]obrescrever  [p]ular existentes  [c]ancelar${C_RST} "
        drain_input
        read_key
        case $KEY in s|S) ;; p|P) skip=1 ;; *) STATUS="Envio cancelado"; return ;; esac
    fi
    local -A exists=()
    for f in "${conflicts[@]}"; do exists[$f]=1; done

    local batch="progress"$'\n' count=0
    for f in "${files[@]}"; do
        (( skip )) && [[ -n ${exists[${f##*/}]+x} ]] && continue
        batch+="-put -r $(sftpq "$f") $(sftpq "$(rpath "$(p_join "$CUR" "${f##*/}")")")"$'\n'
        (( count++ ))
    done
    (( count )) || { STATUS="Nada a enviar"; return; }

    tui_leave
    IN_EXT=1
    echo "${C_TTL}Enviando $count item(s) para $HOST_LABEL:$(disp_path "$CUR")${C_RST}"
    echo
    printf '%s' "$batch" | sftp_batch 2> >(tee "$TMPD/sftp.err" >&2)
    IN_EXT=0
    sleep 0.1
    if [[ -s $TMPD/sftp.err ]]; then
        echo; echo "${C_WRN}⚠ Houve erros (veja acima).${C_RST}"
        STATUS="${C_WRN}⚠ Envio concluído com erros${C_RST}"
    else
        echo; echo "${C_OK}✓ Concluído.${C_RST}"
        STATUS="${C_OK}✓ $count item(s) enviado(s)${C_RST}"
    fi
    pause_key
    tui_enter
    load_dir "$CUR" "${names[0]}"
}

act_filter() {
    prompt "Filtrar por nome (vazio limpa): " "$FILTER"
    FILTER=$REPLY
    reload
}

act_goto() {
    local init=$CUR
    [[ $MODE == win && -z $CUR ]] && init="C:\\"
    prompt "Ir para: " "$init" || return
    local p; p=$(p_normalize "$REPLY")
    FILTER=""
    load_dir "$p"
}

act_home() {
    FILTER=""
    case $MODE in
        local) load_dir "$HOME" ;;
        *) load_dir "$REMOTE_HOME" ;;
    esac
}

act_shell() {
    case $MODE in
        local)
            ext_run sh -c 'cd -- "$1" && echo "(digite exit para voltar ao explorador)" && exec "${SHELL:-/bin/sh}"' sh "$CUR" ;;
        unix)
            ext_run ssh -t "${SSH_BASE[@]}" "$TARGET_HOST" "cd $(sq "$CUR") && echo '(digite exit para voltar ao explorador)' && exec \"\${SHELL:-/bin/sh}\" -l" ;;
        win)
            local enc
            enc=$(utf16le_b64 "Write-Host '(digite exit para voltar ao explorador)';Set-Location -LiteralPath $(psq "${CUR:-$REMOTE_HOME}")")
            ext_run ssh -t "${SSH_BASE[@]}" "$TARGET_HOST" "powershell -NoLogo -NoExit -EncodedCommand $enc" ;;
    esac
    reload
}

show_help() {
    local -a h=(
        "${C_B}Navegação${C_RST}"
        "  ↑ ↓  k j            mover            PgUp PgDn   página        Home End   início/fim"
        "  Enter  →  l         abrir pasta / arquivo"
        "  ←  Backspace        pasta acima"
        "  g                   ir para um caminho digitado       ~   pasta pessoal"
        "  /                   filtrar por nome                  .   mostrar/ocultar ocultos"
        "  R  F5  Ctrl+R       atualizar                         i   informações do item"
        ""
        "${C_B}Seleção${C_RST}"
        "  Espaço              marcar/desmarcar (e desce)        a   marcar/desmarcar todos"
        "  Esc                 limpar marcações e filtro"
        ""
        "${C_B}Arquivos${C_RST}  (as ações valem para os itens marcados ou, se nenhum, o item sob o cursor)"
        "  Enter               abrir: texto no visualizador, imagem no terminal, binário: opções"
        "  v                   ver como texto                    e   editar (\$VISUAL/\$EDITOR ou nano)"
        "  o                   abrir com o aplicativo padrão (xdg-open)"
        "  r  F2               renomear                          m  F7   nova pasta"
        "  c  /  x  /  p       copiar / recortar / colar na pasta atual"
        "  Del  F8             apagar"
        "  d  /  u             baixar do host / enviar para o host (modo SSH)"
        "  !                   abrir um shell na pasta atual (local ou remoto)"
        "  q                   sair"
        ""
        "${C_B}Visualizador de imagens${C_RST}"
        "  → ↓ Espaço  /  ← ↑  próxima / anterior    t  ver como texto    o  app padrão    outra tecla: voltar"
    )
    show_screen "Terminal File Explorer — teclas" "${h[@]}"
}

# ── Imagens ───────────────────────────────────────────────────────────────────

# Envia uma consulta ao terminal e lê a resposta (terminada pela resposta ao DA1)
term_query() {
    local resp="" c old
    old=$(stty -g </dev/tty 2>/dev/null)
    stty raw -echo </dev/tty 2>/dev/null
    printf '%b\e[c' "$1" >/dev/tty
    while IFS= read -rsn1 -t 0.5 c </dev/tty; do
        resp+=$c
        [[ $resp =~ $'\e'\[\?[0-9\;]*c$ ]] && break
    done
    [[ -n $old ]] && stty "$old" </dev/tty 2>/dev/null
    REPLY=$resp
}

detect_img_caps() {
    [[ -n ${IMG_CAPS+x} ]] && return
    IMG_CAPS=" "
    CELL_W=10 CELL_H=20
    term_query '\e_Gi=31,s=1,v=1,a=q,t=d,f=24;AAAA\e\\'
    [[ $REPLY == *'_Gi=31;OK'* ]] && IMG_CAPS+="kitty "
    if [[ $REPLY =~ $'\e'\[\?([0-9\;]*)c ]] && [[ ";${BASH_REMATCH[1]};" == *";4;"* ]]; then IMG_CAPS+="sixel "; fi
    case "${TERM_PROGRAM:-}|${LC_TERMINAL:-}" in
        iTerm.app*|*iTerm2*|WezTerm*|mintty*) IMG_CAPS+="iterm " ;;
    esac
    term_query '\e[16t'
    if [[ $REPLY =~ $'\e'\[6\;([0-9]+)\;([0-9]+)t ]] && (( BASH_REMATCH[1] > 0 )); then
        CELL_H=${BASH_REMATCH[1]} CELL_W=${BASH_REMATCH[2]}
    else
        term_query '\e[14t'
        if [[ $REPLY =~ $'\e'\[4\;([0-9]+)\;([0-9]+)t ]] && (( BASH_REMATCH[1] > 0 )); then
            CELL_H=$(( BASH_REMATCH[1] / ROWS )) CELL_W=$(( BASH_REMATCH[2] / COLS ))
            (( CELL_H > 0 && CELL_W > 0 )) || { CELL_W=10 CELL_H=20; }
        fi
    fi
    TRUECOLOR=0
    [[ ${COLORTERM:-} == truecolor || ${COLORTERM:-} == 24bit || $TERM == *direct* ]] && TRUECOLOR=1
    IM=()
    if have magick; then IM=(magick); elif have convert; then IM=(convert); fi
}

img_kitty_raw() {
    local f=$1 w=$2 h=$3 png="$TMPD/img.png" i n m
    "${IM[@]}" "$f[0]" -auto-orient -resize "$((w * CELL_W))x$((h * CELL_H))>" "png:$png" 2>/dev/null || return 1
    local -a ch
    mapfile -t ch < <(b64 <"$png" | fold -w 4096)
    n=${#ch[@]}
    for (( i = 0; i < n; i++ )); do
        m=$(( i < n - 1 ? 1 : 0 ))
        if (( i == 0 )); then printf '\e_Ga=T,f=100,q=2,m=%d;%s\e\\' "$m" "${ch[i]}"
        else printf '\e_Gm=%d;%s\e\\' "$m" "${ch[i]}"; fi
    done
}

img_iterm_raw() {
    local f=$1 w=$2 h=$3 src=$1
    if (( ${#IM[@]} )); then
        "${IM[@]}" "$f[0]" -auto-orient "png:$TMPD/img.png" 2>/dev/null && src="$TMPD/img.png"
    fi
    printf '\e]1337;File=inline=1;width=%d;height=%d;preserveAspectRatio=1:' "$w" "$h"
    b64 <"$src"
    printf '\a'
}

img_halfblocks() {
    local f=$1 w=$2 h=$3
    "${IM[@]}" "$f[0]" -auto-orient -background black -alpha remove -alpha off -colorspace sRGB -type TrueColor \
        -resize "${w}x$((h * 2))" -depth 8 txt:- 2>/dev/null | awk -v tc="$TRUECOLOR" '
        function c256(r, g, b) { return 16 + 36 * int(r * 5 / 255 + .5) + 6 * int(g * 5 / 255 + .5) + int(b * 5 / 255 + .5) }
        /^#/ { next }
        {
            split($0, a, /[^0-9.]+/)
            x = a[1] + 0; y = a[2] + 0
            R[x "," y] = int(a[3]); G[x "," y] = int(a[4]); B[x "," y] = int(a[5])
            if (x > W) W = x; if (y > H) H = y
        }
        END {
            for (y = 0; y <= H; y += 2) {
                s = ""
                for (x = 0; x <= W; x++) {
                    k = x "," y; k2 = x "," (y + 1)
                    r2 = g2 = b2 = 0
                    if (y + 1 <= H) { r2 = R[k2]; g2 = G[k2]; b2 = B[k2] }
                    if (tc) s = s sprintf("\033[38;2;%d;%d;%d;48;2;%d;%d;%dm\342\226\200", R[k], G[k], B[k], r2, g2, b2)
                    else    s = s sprintf("\033[38;5;%d;48;5;%dm\342\226\200", c256(R[k], G[k], B[k]), c256(r2, g2, b2))
                }
                printf "%s\033[0m\n", s
            }
        }'
}

# Exibe uma imagem em tela cheia; deixa em KEY a tecla pressionada
img_view() {
    local f=$1 label=$2 w h how="" rc=0
    detect_img_caps
    term_size
    w=$COLS h=$(( ROWS - 1 ))
    printf '\e[H\e[2J'
    if [[ -n ${TFE_IMG_VIEWER:-} ]]; then
        how=$TFE_IMG_VIEWER
        local -a v; read -ra v <<<"$TFE_IMG_VIEWER"
        "${v[@]}" "$f"; rc=$?
    elif [[ $IMG_CAPS == *" kitty "* ]] && { have kitten || have chafa || (( ${#IM[@]} )); }; then
        how="protocolo kitty"
        if have kitten; then kitten icat --stdin=no --place "${w}x${h}@0x0" -- "$f" 2>/dev/null; rc=$?
        elif have chafa; then chafa -f kitty --animate=off -s "${w}x${h}" -- "$f" 2>/dev/null; rc=$?
        else img_kitty_raw "$f" "$w" "$h"; rc=$?; fi
    elif [[ $IMG_CAPS == *" iterm "* ]]; then
        how="protocolo iTerm2"
        if [[ ${TERM_PROGRAM:-} == WezTerm ]] && have wezterm; then wezterm imgcat --height "$h" "$f" 2>/dev/null; rc=$?
        else img_iterm_raw "$f" "$w" "$h"; rc=$?; fi
    elif [[ $IMG_CAPS == *" sixel "* ]] && { have chafa || have img2sixel || (( ${#IM[@]} )); }; then
        how="sixel"
        if have chafa; then chafa -f sixels --animate=off -s "${w}x${h}" -- "$f" 2>/dev/null; rc=$?
        elif (( ${#IM[@]} )); then "${IM[@]}" "$f[0]" -auto-orient -resize "$((w * CELL_W))x$((h * CELL_H))>" sixel:- 2>/dev/null; rc=$?
        else img2sixel -w $(( w * CELL_W )) "$f" 2>/dev/null; rc=$?; fi
    elif have chafa; then
        how="chafa (caracteres)"
        chafa --animate=off -s "${w}x${h}" -- "$f" 2>/dev/null; rc=$?
    elif have timg; then
        how="timg"
        timg -g"${w}x${h}" -- "$f" 2>/dev/null; rc=$?
    elif have viu; then
        how="viu"
        viu -h "$h" "$f" 2>/dev/null; rc=$?
    elif (( ${#IM[@]} )); then
        how="blocos coloridos"
        img_halfblocks "$f" "$w" "$h"; rc=$?
    else
        how="nenhum visualizador"
        rc=1
    fi
    local dims=""
    if (( ${#IM[@]} )); then
        if [[ ${IM[0]} == magick ]]; then dims=$(magick identify -format '%wx%h' "$f[0]" 2>/dev/null)
        elif have identify; then dims=$(identify -format '%wx%h' "$f[0]" 2>/dev/null); fi
    fi
    if (( rc != 0 )) && [[ $how == "nenhum visualizador" ]]; then
        printf '\e[2;2HNenhum visualizador de imagens disponível.'
        printf '\e[4;2HInstale o %schafa%s (recomendado) ou o ImageMagick: pressione %si%s para instalar agora.' "$C_B" "$C_RST" "$C_B" "$C_RST"
    elif (( rc != 0 )); then
        printf '\e[%d;1H%sNão foi possível exibir a imagem (%s).%s' "$((ROWS - 1))" "$C_ERR" "$how" "$C_RST"
    fi
    printf '\e[%d;1H\e[0m\e[K%s %s %s %s  %s[%s]  ←/→ anterior/próxima  t texto  o app padrão  outra tecla: voltar%s' \
        "$ROWS" "$C_REV" "$label" "${dims:+($dims)}" "$C_RST" "$C_DIM" "$how" "$C_RST"
    drain_input
    read_key
    [[ $IMG_CAPS == *" kitty "* ]] && printf '\e_Ga=d,d=A\e\\'
    printf '\e[0m\e[H\e[2J'
    if [[ $how == "nenhum visualizador" && $KEY == [iI] ]]; then
        printf '\e[?7h'
        ensure_cmd chafa "exibir imagens no terminal" || ensure_cmd magick "exibir imagens no terminal"
        printf '\e[?7l'
        KEY=AGAIN
    fi
}

is_image_name() { [[ ${1,,} =~ $IMG_EXT_RE ]]; }

image_loop() {
    local idx=$1 f=$2 i n=${#E_NAME[@]}
    while :; do
        CURSOR=$idx
        img_view "$f" "${E_NAME[idx]}"
        case $KEY in
            AGAIN) continue ;;
            RIGHT|DOWN|SPACE|j|l|n)
                for (( i = idx + 1; i < n; i++ )); do (( E_DIR[i] )) || ! is_image_name "${E_NAME[i]}" || break; done
                (( i < n )) || continue
                idx=$i ;;
            LEFT|UP|BACKSPACE|k|h|N)
                for (( i = idx - 1; i >= 0; i-- )); do (( E_DIR[i] )) || ! is_image_name "${E_NAME[i]}" || break; done
                (( i >= 0 )) || continue
                idx=$i ;;
            t|T) text_view "$f" "${E_NAME[idx]}"; return ;;
            o|O) xdg_open_file "$f"; return ;;
            *) return ;;
        esac
        CURSOR=$idx
        fetch_local "$(p_join "$CUR" "${E_NAME[idx]}")" "${E_SIZE[idx]}" || return
        f=$REPLY
    done
}

# ── Seleção de destino e conexão ──────────────────────────────────────────────

# Menu simples com setas. $1 = título, demais = itens. Índice escolhido em REPLY.
menu_select() {
    local title=$1 cur=0 i out
    shift
    local -a items=("$@")
    local n=${#items[@]}
    while :; do
        term_size
        out=$'\e[H\e[2J'"
 ${C_TTL}${title}${C_RST}"$'\n\n'
        for (( i = 0; i < n; i++ )); do
            if (( i == cur )); then out+=" ${C_REV} $PTR ${items[i]} ${C_RST}"$'\e[K\n'
            else out+="    ${items[i]}"$'\e[K\n'; fi
        done
        out+=$'\n'" ${C_DIM}↑↓ escolher   Enter confirmar   q sair${C_RST}"
        printf '%s' "$out"
        read_key
        case $KEY in
            UP|k) (( cur = (cur - 1 + n) % n )) ;;
            DOWN|j|TAB) (( cur = (cur + 1) % n )) ;;
            HOME) cur=0 ;;
            END) cur=$(( n - 1 )) ;;
            ENTER|RIGHT|l) REPLY=$cur; return 0 ;;
            q|Q|ESC|EOF) return 1 ;;
            [1-9]) (( KEY <= n )) && { REPLY=$(( KEY - 1 )); return 0; } ;;
        esac
    done
}

ssh_config_hosts() {
    [[ -r $HOME/.ssh/config ]] || return
    awk 'tolower($1) == "host" { for (i = 2; i <= NF; i++) if ($i !~ /[*?!]/) print $i }' "$HOME/.ssh/config" | awk '!seen[$0]++'
}

declare -A MS_USER=() MS_HOST=() MS_PORT=() MS_PASS=()
MS_NAMES=()

load_multissh_hosts() {
    (( ${#MS_NAMES[@]} )) && return
    [[ -r $MULTISSH_HOSTS ]] || return
    local name user host port pass
    local py='import json,sys
for k,v in sorted(json.load(open(sys.argv[1])).items()):
    print("\t".join([k,str(v.get("user","")),str(v.get("host","")),str(v.get("port",22)),str(v.get("password") or "")]))'
    while IFS=$'\t' read -r name user host port pass; do
        [[ -z $name || -z $host ]] && continue
        MS_NAMES+=("$name"); MS_USER[$name]=$user; MS_HOST[$name]=$host; MS_PORT[$name]=${port:-22}; MS_PASS[$name]=$pass
    done < <(
        if have python3; then python3 -c "$py" "$MULTISSH_HOSTS" 2>/dev/null
        elif have jq; then jq -r 'to_entries | sort_by(.key)[] | [.key, (.value.user // ""), (.value.host // ""), ((.value.port // 22) | tostring), (.value.password // "")] | @tsv' "$MULTISSH_HOSTS" 2>/dev/null
        fi
    )
}

# Define TARGET_HOST/TARGET_OPTS/HOST_LABEL/PASSWORD a partir de um destino textual
resolve_target() {
    local t=$1
    TARGET_OPTS=() PASSWORD=""
    if [[ -n ${MS_HOST[$t]+x} ]]; then
        TARGET_HOST=${MS_HOST[$t]}
        TARGET_OPTS=(-o "Port=${MS_PORT[$t]}")
        [[ -n ${MS_USER[$t]} ]] && TARGET_OPTS+=(-o "User=${MS_USER[$t]}")
        PASSWORD=${MS_PASS[$t]}
        HOST_LABEL=$t
        return
    fi
    HOST_LABEL=$t
    if [[ $t =~ ^(.+@)?([^:@]+):([0-9]+)$ ]]; then
        TARGET_HOST="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
        TARGET_OPTS=(-o "Port=${BASH_REMATCH[3]}")
    else
        TARGET_HOST=$t
    fi
}

ssh_connect() {
    if ! have ssh || ! have sftp; then
        ensure_cmd ssh "acessar outros PCs via SSH" && ensure_cmd sftp "transferir arquivos via SSH" || {
            echo "${C_ERR}O cliente SSH (ssh/sftp) é necessário para o modo remoto.${C_RST}"; return 1; }
    fi
    SSH_BASE=(-o "ControlPath=$TMPD/ctl" -o ServerAliveInterval=30 -o ServerAliveCountMax=4 "${TARGET_OPTS[@]}")
    rm -f -- "$TMPD/ctl"
    echo "Conectando a ${C_B}$HOST_LABEL${C_RST}..."
    local -a master=(ssh "${SSH_BASE[@]}" -o ControlMaster=yes -o ControlPersist=yes -fN "$TARGET_HOST")
    local rc
    if [[ -n $PASSWORD ]] && { have sshpass || ensure_cmd sshpass "usar a senha cadastrada no multi-ssh"; }; then
        SSHPASS=$PASSWORD sshpass -e "${master[@]}"
        rc=$?
    else
        [[ -n $PASSWORD ]] && echo "${C_DIM}(sem sshpass: digite a senha manualmente)${C_RST}"
        "${master[@]}"
        rc=$?
    fi
    if (( rc != 0 )) || [[ ! -S $TMPD/ctl ]]; then
        echo "${C_ERR}✗ Falha ao conectar em $HOST_LABEL (código $rc).${C_RST}"
        return 1
    fi

    local out
    out=$(ssh -n "${SSH_BASE[@]}" "$TARGET_HOST" 'echo "$HOME"' 2>/dev/null | tr -d '\r')
    if [[ $out == /* ]]; then
        MODE=unix
        REMOTE_HOME=$out
    else
        MODE=win
        out=$(win_ps '$o.Write($env:USERPROFILE)' 2>/dev/null | tr -d '\r')
        out=${out#$'\xef\xbb\xbf'}
        if [[ -z $out ]]; then
            echo "${C_ERR}✗ Host não parece ser Unix e o PowerShell não respondeu.${C_RST}"
            ssh "${SSH_BASE[@]}" -O exit "$TARGET_HOST" >/dev/null 2>&1
            return 1
        fi
        REMOTE_HOME=$out
    fi
    echo "${C_OK}✓ Conectado${C_RST} (sistema: $([[ $MODE == win ]] && echo Windows || echo Linux/Unix), pasta inicial: $REMOTE_HOME)"
    return 0
}

disconnect() {
    if [[ -S $TMPD/ctl ]]; then ssh "${SSH_BASE[@]}" -O exit "$TARGET_HOST" >/dev/null 2>&1; fi
    SSH_BASE=()
}

# Prepara o modo escolhido. $1 = local | destino ssh, $2 = caminho inicial (opcional)
start_session() {
    local target=$1 path=${2-}
    CLIP_ITEMS=() MARKED=() FILTER="" CUR=""
    if [[ $target == local ]]; then
        MODE=local HOST_LABEL=local
        path=${path:-$START_DIR}
        [[ $path == /* ]] || path="$START_DIR/$path"
    else
        resolve_target "$target"
        ssh_connect || return 1
        if [[ -n $path ]]; then path=$(CUR=$REMOTE_HOME; p_normalize "$path"); else path=$REMOTE_HOME; fi
    fi
    if ! load_dir "$path"; then
        local fallback
        case $MODE in local) fallback=/ ;; unix) fallback=/ ;; win) fallback="" ;; esac
        load_dir "$fallback" || { echo "${C_ERR}$(printf '%s' "$STATUS" | sed 's/\x1b\[[0-9;]*m//g')${C_RST}"; return 1; }
    fi
    return 0
}

start_menu() {
    local -a labels=() targets=()
    local h w=0 name
    load_multissh_hosts
    local -a cfg=()
    mapfile -t cfg < <(ssh_config_hosts)
    for h in "${cfg[@]}" "${MS_NAMES[@]}"; do (( ${#h} > w )) && w=${#h}; done

    labels+=("$I_PC  Este computador (local)"); targets+=(local)
    for h in "${cfg[@]}"; do
        printf -v name '%s  %-*s  %s' "$I_NET" "$w" "$h" "(~/.ssh/config)"
        labels+=("$name"); targets+=("$h")
    done
    for h in "${MS_NAMES[@]}"; do
        printf -v name '%s  %-*s  %s' "$I_NET" "$w" "$h" "${MS_USER[$h]:+${MS_USER[$h]}@}${MS_HOST[$h]}:${MS_PORT[$h]} (multi-ssh)"
        labels+=("$name"); targets+=("$h")
    done
    labels+=("$I_ADD  Outro host SSH (digitar usuario@host[:porta])"); targets+=("")

    tui_enter
    if ! menu_select "Terminal File Explorer — o que deseja navegar?" "${labels[@]}"; then
        tui_leave; return 1
    fi
    local t=${targets[REPLY]}
    if [[ -z $t ]]; then
        term_size
        printf '\e[%d;1H' "$((ROWS - 1))"
        if ! prompt "Destino (usuario@host[:porta]): "; then tui_leave; return 2; fi
        t=$REPLY
    fi
    tui_leave
    MENU_TARGET=$t
    return 0
}

# ── Laço principal ────────────────────────────────────────────────────────────

main_loop() {
    tui_enter
    while :; do
        render
        read_key
        local prev=$STATUS
        STATUS=""
        case $KEY in
            RESIZE|CTRL_L) STATUS=$prev; printf '\e[2J' ;;
            UP|k)        (( CURSOR-- )) ;;
            DOWN|j)      (( CURSOR++ )) ;;
            PGUP)        (( CURSOR -= LIST_H )) ;;
            PGDN)        (( CURSOR += LIST_H )) ;;
            HOME)        CURSOR=0 ;;
            END)         CURSOR=$(( ${#E_NAME[@]} - 1 )) ;;
            ENTER|RIGHT|l) act_open ;;
            LEFT|BACKSPACE|h) act_up ;;
            SPACE)       act_mark; (( CURSOR++ )) ;;
            a|A)         act_mark_all ;;
            ESC)         MARKED=(); [[ -n $FILTER ]] && { FILTER=""; reload; } ;;
            v|V)         act_view ;;
            e|E)         act_edit ;;
            o|O)         act_xdg ;;
            i|I)         act_info ;;
            r|F2)        act_rename ;;
            m|M|F7|+)    act_mkdir ;;
            c|C|y)       act_clip copy ;;
            x|X)         act_clip move ;;
            p|P)         act_paste ;;
            DEL|F8)      act_delete ;;
            d|D)         act_download ;;
            u|U)         act_upload ;;
            R|F5|CTRL_R) reload && STATUS="Atualizado" ;;
            .)           (( SHOW_HIDDEN = !SHOW_HIDDEN )); reload ;;
            /)           act_filter ;;
            g|G)         act_goto ;;
            '~')         act_home ;;
            '!'|s|S)     act_shell ;;
            '?'|F1)      show_help ;;
            q|Q|EOF)     break ;;
        esac
    done
    tui_leave
}

usage() {
    sed -n '/^# Uso:/,/^# Recursos:/p' "$0" 2>/dev/null | sed '$d; s/^# \{0,1\}//'
    [[ -r $0 ]] || echo "Uso: $SCRIPT_NAME [local|usuario@host[:porta]|alias] [caminho] | --deps"
}

main() {
    case ${1-} in
        -h|--help) usage; exit 0 ;;
        --deps) deps_check 1; exit 0 ;;
    esac
    if [[ ! -t 0 || ! -t 1 ]]; then
        echo "Erro: execute em um terminal interativo." >&2
        exit 1
    fi
    deps_check 0
    load_multissh_hosts

    if [[ -n ${1-} ]]; then
        start_session "$1" "${2-}" || exit 1
        main_loop
        exit 0
    fi

    while :; do
        MENU_TARGET=""
        start_menu
        case $? in 1) exit 0 ;; 2) continue ;; esac
        if start_session "$MENU_TARGET"; then
            main_loop
            disconnect
        else
            pause_key
        fi
    done
}

main "$@"
