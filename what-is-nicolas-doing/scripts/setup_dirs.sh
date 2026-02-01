#!/usr/bin/env bash

set -e

PROJECT_NAME="what-is-nicolas-doing"

echo "Criando estrutura do projeto: $PROJECT_NAME"

mkdir -p "$PROJECT_NAME/backend/config"
mkdir -p "$PROJECT_NAME/backend/blog/migrations"
mkdir -p "$PROJECT_NAME/backend/blog/templates/blog"

touch "$PROJECT_NAME/backend/config/settings.py"
touch "$PROJECT_NAME/backend/config/urls.py"
touch "$PROJECT_NAME/backend/config/wsgi.py"

touch "$PROJECT_NAME/backend/blog/models.py"
touch "$PROJECT_NAME/backend/blog/views.py"
touch "$PROJECT_NAME/backend/blog/admin.py"
touch "$PROJECT_NAME/backend/blog/urls.py"
touch "$PROJECT_NAME/backend/blog/migrations/__init__.py"

touch "$PROJECT_NAME/requirements.txt"
touch "$PROJECT_NAME/README.md"

echo "Estrutura criada com sucesso."
