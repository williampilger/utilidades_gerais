#!/bin/bash
# ============================================================
#  cc — Claude Code isolado em Docker
#
#  Uso:
#    claude.sh --install     Cria a imagem Docker (rodar uma vez)
#    claude.sh               Sobe o Claude Code na pasta atual
#    claude.sh --print "..."  Passa flags direto pro claude
# ============================================================

IMAGE_NAME="claude-code-sandbox"
DOCKERFILE_DIR="$HOME/.config/claude-code-docker"

# ── Helpers ─────────────────────────────────────────────────

_info() { echo -e "\033[1;34m[cc]\033[0m $*"; }
_success() { echo -e "\033[1;32m[cc]\033[0m $*"; }
_warn() { echo -e "\033[1;33m[cc]\033[0m $*"; }
_error() {
  echo -e "\033[1;31m[cc]\033[0m $*"
  exit 1
}

# ── Subcomando: --install ────────────────────────────────────

cmd_install() {
  # Verifica dependências
  command -v docker &>/dev/null || _error "Docker não encontrado. Instale em https://docs.docker.com/engine/install/"

  # Verifica se a API key está definida
  if [ -z "$ANTHROPIC_API_KEY" ]; then
    _warn "ANTHROPIC_API_KEY não está definida no ambiente. Obtenha uma em https://platform.claude.com/settings/workspaces/default/keys"
    _warn "Adicione ao seu ~/.bashrc ou ~/.zshrc:"
    echo ""
    echo '    export ANTHROPIC_API_KEY="sk-ant-..."'
    echo ""
    read -rp "[cc] Continuar mesmo assim? (s/N): " confirm
    [[ "$confirm" =~ ^[sS]$ ]] || exit 0
  fi

  # Cria diretório da imagem
  mkdir -p "$DOCKERFILE_DIR"

  _info "Criando Dockerfile em $DOCKERFILE_DIR ..."

  cat >"$DOCKERFILE_DIR/Dockerfile" <<'EOF'
FROM node:22-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspace

ENTRYPOINT ["claude"]
EOF

  _info "Construindo imagem Docker '$IMAGE_NAME' (pode demorar na primeira vez)..."
  docker build -t "$IMAGE_NAME" "$DOCKERFILE_DIR" ||
    _error "Falha ao construir a imagem Docker."

  _success "Imagem '$IMAGE_NAME' criada com sucesso!"

  # Auto-instalação do script no PATH
  INSTALL_PATH="$HOME/scripts/claude"
  SCRIPT_PATH="$(realpath "$0")"

  mkdir -p "$HOME/bin"

  if [ "$SCRIPT_PATH" != "$INSTALL_PATH" ]; then
    cp "$SCRIPT_PATH" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"
    _success "Script instalado em $INSTALL_PATH"
  fi

  # Garante ~/bin no PATH no bashrc e zshrc
  for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC" ] && ! grep -q 'HOME/bin' "$RC"; then
      echo 'export PATH="$HOME/bin:$PATH"' >>"$RC"
      _info "PATH atualizado em $RC"
    fi
  done

  echo ""
  _info "Recarregue o shell ou rode:"
  echo "    source ~/.bashrc"
  echo ""
  _info "Depois use em qualquer projeto:"
  echo "    cd /seu/projeto"
  echo "    claude"
  echo ""
  _info "Para bloquear arquivos específicos por projeto, crie um .claudeignore:"
  echo "    echo '.env.prod' >> .claudeignore"
  echo "    echo '.env.staging' >> .claudeignore"
}

# ── Subcomando: rodar ────────────────────────────────────────

cmd_run() {
  # Verifica se a imagem existe
  if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
    _error "Imagem '$IMAGE_NAME' não encontrada. Rode primeiro: cc --install"
  fi

  # Verifica API key
  if [ -z "$ANTHROPIC_API_KEY" ]; then
    _error "ANTHROPIC_API_KEY não está definida. Adicione ao ~/.bashrc e rode: source ~/.bashrc"
  fi

  # Monta bloqueios do .claudeignore
  BLOCKED_MOUNTS=""
  BLOCKED_LIST=()

  if [ -f "$(pwd)/.claudeignore" ]; then
    while IFS= read -r line; do
      [[ -z "$line" || "$line" == \#* ]] && continue
      # Remove espaços extras
      line="$(echo "$line" | xargs)"
      BLOCKED_MOUNTS="$BLOCKED_MOUNTS -v /dev/null:/workspace/$line"
      BLOCKED_LIST+=("$line")
    done <"$(pwd)/.claudeignore"

    if [ ${#BLOCKED_LIST[@]} -gt 0 ]; then
      _info "Arquivos bloqueados (.claudeignore): ${BLOCKED_LIST[*]}"
    fi
  fi

  _info "Iniciando Claude Code em: $(pwd)"

  # shellcheck disable=SC2086
  docker run -it --rm \
    -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
    -v "$(pwd)":/workspace \
    --network bridge \
    $BLOCKED_MOUNTS \
    "$IMAGE_NAME" "$@"
}

# ── Roteador principal ───────────────────────────────────────

case "${1:-}" in
--install)
  shift
  cmd_install "$@"
  ;;
--help | -h)
  echo ""
  echo "  claude --install     Cria a imagem Docker e instala o script no PATH"
  echo "  claude               Roda o Claude Code na pasta atual"
  echo "  claude [flags]       Passa flags direto pro claude (ex: claude --print '...')"
  echo ""
  echo "  Para bloquear arquivos por projeto, crie .claudeignore na raiz do projeto."
  echo ""
  ;;
*)
  cmd_run "$@"
  ;;
esac
