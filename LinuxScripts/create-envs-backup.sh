#!/bin/bash

# Script para criar uma cópia de todos os `.env*` no diretório escolhido para outro.
#  - Toda a árvore de pastas é criada
#  - Todos arquivos .env são copiados (.env.prod, .env.sample, etc...)

# --- Configurações ---
ORIGEM="/media/caminho/do/seu/github" #caminho que deve ser varrido
DESTINO="." # Diretório atual

echo "Iniciando backup dos arquivos .env..."

rsync -amv --include='*/' --include='.env*' --exclude='*' "$ORIGEM" "$DESTINO"

echo "Backup dos ENV files concluído de '$ORIGEM' para '$DESTINO'"
