#!/usr/bin/env bash

set -e

# Resolve o diretório raiz do projeto (independente de onde o script é chamado)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "========================================"
echo " Bootstrap — what-is-nicolas-doing"
echo "========================================"
echo "Projeto em: $PROJECT_ROOT"
echo

step () {
  echo
  echo "▶ $1"
}

# Verificações básicas
step "Verificando dependências do sistema"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Erro: python3 não encontrado."
  exit 1
fi

# setup_env cria o venv e instala django, então django-admin
# pode ainda não existir no sistema
step "Python: $(python3 --version)"

# Garantir permissão de execução
step "Garantindo permissão de execução dos scripts"

chmod +x "$SCRIPT_DIR"/*.sh

# Execução orquestrada
step "Criando estrutura de diretórios"
"$SCRIPT_DIR/setup_dirs.sh"

step "Inicializando projeto Django"
"$SCRIPT_DIR/setup_django.sh"

step "Criando app blog"
"$SCRIPT_DIR/setup_blog_app.sh"

step "Criando models"
"$SCRIPT_DIR/setup_models.sh"

step "Criando templates"
"$SCRIPT_DIR/setup_templates.sh"

step "Configurando ambiente virtual"
"$SCRIPT_DIR/setup_env.sh"

echo
echo "========================================"
echo " Bootstrap concluído com sucesso 🎉"
echo
echo "Próximos passos:"
echo "  cd what-is-nicolas-doing"
echo "  source .venv/bin/
