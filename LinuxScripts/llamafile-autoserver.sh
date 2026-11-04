#!/usr/bin/env bash
# =============================================================================
#  llamafile.sh — LLM local portátil para programação (Linux / macOS)
#
#  Uso:   ./llamafile.sh            (menu de modelos)
#         ./llamafile.sh 4          (escolhe direto o modelo nº 4)
#
#  Variáveis opcionais:
#     LLAMAFILE_HOME  pasta de dados (padrão: pasta do script)
#     PORT            porta do servidor (padrão: 8080)
#     CTX             contexto em tokens (padrão: 16384)
#     HOST            bind (padrão: 127.0.0.1; use 0.0.0.0 p/ expor na rede)
#
#  Ao encerrar o script (Ctrl+C, fechar o terminal, kill), o llamafile é
#  encerrado junto.
# =============================================================================
set -uo pipefail

# ---------------------------------------------------------------- config -----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"
[[ -f "$SCRIPT_DIR/llamafile.sh" ]] || SCRIPT_DIR="$PWD/llamafile-portable"  # rodando via pipe
BASE="${LLAMAFILE_HOME:-$SCRIPT_DIR}"
BIN_DIR="$BASE/bin"
MODELS_DIR="$BASE/models"
BIN="$BIN_DIR/llamafile"

PORT="${PORT:-8080}"
CTX="${CTX:-16384}"
HOST="${HOST:-127.0.0.1}"
QUANT="Q4_K_M"

LLAMAFILE_FALLBACK_URL="https://huggingface.co/mozilla-ai/llamafile_0.10/resolve/main/llamafile_0.10.1"

# nome | repo Hugging Face | tamanho aprox. | descrição
MODELS=(
  "Qwen2.5-Coder 1.5B|Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF|~1 GB|autocomplete, PC fraco"
  "Qwen2.5-Coder 3B|Qwen/Qwen2.5-Coder-3B-Instruct-GGUF|~2 GB|notebook sem GPU"
  "Qwen3.5 4B|unsloth/Qwen3.5-4B-GGUF|~3 GB|generalista leve, tool calling"
  "Qwen2.5-Coder 7B  [recomendado]|Qwen/Qwen2.5-Coder-7B-Instruct-GGUF|~4.7 GB|TS/React/SQL, 16 GB RAM"
  "Qwen3.5 9B|unsloth/Qwen3.5-9B-GGUF|~5.5 GB|raciocinio / agente"
  "Qwen2.5-Coder 14B|Qwen/Qwen2.5-Coder-14B-Instruct-GGUF|~9 GB|GPU 12-16 GB"
  "Qwen3-Coder 30B-A3B (MoE)|unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF|~18 GB|32 GB RAM, roda ate em CPU"
)

# ---------------------------------------------------------------- utils ------
c_b=$'\e[1m'; c_g=$'\e[32m'; c_y=$'\e[33m'; c_r=$'\e[31m'; c_0=$'\e[0m'
info() { echo "${c_g}==>${c_0} $*"; }
warn() { echo "${c_y}!!${c_0} $*" >&2; }
die()  { echo "${c_r}xx${c_0} $*" >&2; exit 1; }

command -v curl >/dev/null || die "curl não encontrado. Instale (ex.: sudo apt install curl)."

download() {  # url destino — com retomada
  local url="$1" out="$2"
  curl -L --fail --retry 3 -C - --progress-bar -o "$out.part" "$url" \
    && mv -f "$out.part" "$out"
}

# ---------------------------------------------------------------- binário ----
ensure_llamafile() {
  [[ -x "$BIN" ]] && return 0
  mkdir -p "$BIN_DIR"
  info "Baixando llamafile (última release)..."
  local url
  url=$(curl -fsSL https://api.github.com/repos/mozilla-ai/llamafile/releases/latest 2>/dev/null \
        | grep -o '"browser_download_url": *"[^"]*"' | sed 's/.*"\(http[^"]*\)"/\1/' \
        | grep -E '/llamafile(-[0-9][0-9.]*)?$' | head -n1)
  if [[ -z "$url" ]]; then
    warn "Não consegui consultar o GitHub; usando fallback."
    url="$LLAMAFILE_FALLBACK_URL"
  fi
  echo "   $url"
  download "$url" "$BIN" || die "Falha ao baixar o llamafile."
  chmod +x "$BIN"
  [[ "$(uname)" == "Darwin" ]] && xattr -d com.apple.quarantine "$BIN" 2>/dev/null
  return 0
}

# Algumas distros têm binfmt (WINE/WSL) que intercepta o formato APE.
# Nesse caso, rodar via "sh" resolve.
RUNNER=()
detect_runner() {
  if "$BIN" --version >/dev/null 2>&1; then RUNNER=("$BIN")
  elif sh "$BIN" --version >/dev/null 2>&1; then RUNNER=(sh "$BIN")
  else die "O llamafile não executou nesta máquina. Veja: https://docs.mozilla.ai/llamafile (Troubleshooting)."
  fi
}

# ---------------------------------------------------------------- modelos ----
model_dir() { echo "$MODELS_DIR/${1//\//__}"; }

first_gguf() {  # menor nome .gguf (para split, é a parte 00001)
  ls -1 "$1"/*.gguf 2>/dev/null | sort | head -n1
}

ensure_model() {  # repo -> imprime caminho do .gguf principal
  local repo="$1" dir; dir="$(model_dir "$repo")"
  mkdir -p "$dir"
  if [[ -f "$dir/.complete" ]]; then first_gguf "$dir"; return 0; fi

  info "Listando arquivos de $repo ..." >&2
  local all files
  all=$(curl -fsSL "https://huggingface.co/api/models/$repo/tree/main?recursive=true" \
        | grep -o '"path":"[^"]*"' | sed 's/"path":"\(.*\)"/\1/' \
        | grep -iE "(^|[/_.-])${QUANT}(-[0-9]{5}-of-[0-9]{5})?\.gguf$" \
        | grep -vi 'mmproj' | sort)
  files=$(grep -v 'UD-' <<< "$all")          # prefere a quantização "padrão"
  [[ -n "$files" ]] || files="$all"           # senão aceita a Unsloth Dynamic
  [[ -n "$files" ]] || die "Nenhum arquivo $QUANT encontrado em $repo."

  local f
  while IFS= read -r f; do
    info "Baixando $(basename "$f")" >&2
    download "https://huggingface.co/$repo/resolve/main/$f" "$dir/$(basename "$f")" >&2 \
      || die "Falha no download de $f"
  done <<< "$files"
  touch "$dir/.complete"
  first_gguf "$dir"
}

choose_model() {
  local choice="${1:-}"
  if [[ -z "$choice" ]]; then
    echo
    echo "${c_b}Modelos disponíveis ($QUANT):${c_0}"
    local i=1 m name repo size desc mark
    for m in "${MODELS[@]}"; do
      IFS='|' read -r name repo size desc <<< "$m"
      mark="   "; [[ -f "$(model_dir "$repo")/.complete" ]] && mark="${c_g} ✓ ${c_0}"
      printf "%s%2d) %-32s %-8s %s\n" "$mark" "$i" "$name" "$size" "$desc"
      ((i++))
    done
    echo "     (✓ = já baixado)"
    echo
    read -rp "Escolha [1-${#MODELS[@]}] (padrão 4): " choice
    choice="${choice:-4}"
  fi
  [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#MODELS[@]} )) \
    || die "Opção inválida: $choice"
  SELECTED="${MODELS[$((choice-1))]}"
}

# ---------------------------------------------------------------- execução ---
PID=""
cleanup() {
  trap - EXIT INT TERM HUP
  if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
    echo; info "Encerrando llamafile (PID $PID)..."
    kill -TERM "$PID" 2>/dev/null
    for _ in {1..20}; do kill -0 "$PID" 2>/dev/null || break; sleep 0.25; done
    kill -KILL "$PID" 2>/dev/null
  fi
  exit 0
}
trap cleanup EXIT INT TERM HUP

open_browser() {
  if command -v xdg-open >/dev/null; then xdg-open "$1" >/dev/null 2>&1 &
  elif command -v open >/dev/null; then open "$1"
  fi
}

main() {
  mkdir -p "$BASE"
  ensure_llamafile
  detect_runner
  choose_model "${1:-}"

  local name repo
  IFS='|' read -r name repo _ _ <<< "$SELECTED"
  name="${name%% \[*}"; name="${name%"${name##*[! ]}"}"   # tira " [recomendado]"
  local gguf; gguf="$(ensure_model "$repo")" || exit 1

  if curl -fs "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
    die "Já existe algo respondendo na porta $PORT. Use PORT=8081 ./llamafile.sh"
  fi

  info "Iniciando ${c_b}$name${c_0} (ctx $CTX, porta $PORT)"
  "${RUNNER[@]}" --server -m "$gguf" -c "$CTX" -ngl 999 \
      --host "$HOST" --port "$PORT" --alias "$name" \
      > "$BASE/llamafile.log" 2>&1 &
  PID=$!

  printf "   carregando modelo"
  until curl -fs "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; do
    kill -0 "$PID" 2>/dev/null || { echo; tail -n 30 "$BASE/llamafile.log"; die "llamafile encerrou ao iniciar (log acima)."; }
    printf "."; sleep 1
  done
  echo

  cat <<EOF

${c_b}Pronto!${c_0}
  Chat (navegador) : http://localhost:$PORT
  API OpenAI       : http://localhost:$PORT/v1   (api key: qualquer)
  Log              : $BASE/llamafile.log

  ${c_y}Ctrl+C${c_0} (ou fechar este terminal) encerra tudo.

EOF
  open_browser "http://localhost:$PORT"
  wait "$PID"
  warn "llamafile terminou sozinho. Últimas linhas do log:"
  tail -n 15 "$BASE/llamafile.log"
}

main "$@"
