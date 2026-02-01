#!/usr/bin/env bash

set -e

PROJECT_NAME="what-is-nicolas-doing"
BACKEND_DIR="$PROJECT_NAME/backend"
DJANGO_PROJECT_NAME="config"

echo "Inicializando projeto Django em $BACKEND_DIR"

if [ ! -d "$BACKEND_DIR" ]; then
  echo "Erro: diretório $BACKEND_DIR não existe. Execute setup_dirs.sh primeiro."
  exit 1
fi

if [ -f "$BACKEND_DIR/manage.py" ]; then
  echo "Projeto Django já inicializado. Pulando etapa."
  exit 0
fi

cd "$BACKEND_DIR"

django-admin startproject "$DJANGO_PROJECT_NAME" .

echo "Projeto Django criado com sucesso."
