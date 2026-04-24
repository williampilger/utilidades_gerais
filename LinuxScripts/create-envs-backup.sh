#!/bin/bash

# --- Configurações ---
ORIGEM="/media/wilger/OS/github"
DESTINO="." # Diretório atual

echo "Iniciando backup dos arquivos .env..."

rsync -amv --include='*/' --include='.env*' --exclude='*' "$ORIGEM" "$DESTINO"

echo "✅ Backup concluído de '$ORIGEM' para '$DESTINO'"