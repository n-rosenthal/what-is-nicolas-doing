#!/usr/bin/env bash

set -e

PROJECT_NAME="what-is-nicolas-doing"
BACKEND_DIR="$PROJECT_NAME/backend"
APP_NAME="blog"
DJANGO_PROJECT_NAME="config"

echo "========================================"
echo " Setup Django app: $APP_NAME"
echo "========================================"

# Verificações
if [ ! -f "$BACKEND_DIR/manage.py" ]; then
    echo "Erro: manage.py não encontrado. Execute setup_django.sh primeiro."
    exit 1
fi

cd "$BACKEND_DIR"

if [ -d "$APP_NAME" ]; then
    echo "App '$APP_NAME' já existe. Abortando."
    exit 1
fi

# Criar app
echo "▶ Criando app Django '$APP_NAME'"
python manage.py startapp "$APP_NAME"

# Garantir estrutura de templates
echo "▶ Garantindo estrutura de templates"
mkdir -p "$APP_NAME/templates/$APP_NAME"

# Registrar app no INSTALLED_APPS
SETTINGS_FILE="$DJANGO_PROJECT_NAME/settings.py"

echo "▶ Registrando app em INSTALLED_APPS"

if grep -q "'$APP_NAME'" "$SETTINGS_FILE"; then
    echo "App já registrada em INSTALLED_APPS"
else
    sed -i "/INSTALLED_APPS = \[/a\    '$APP_NAME'," "$SETTINGS_FILE"
fi

# Criar urls.py da app se não existir
APP_URLS="$APP_NAME/urls.py"

if [ ! -f "$APP_URLS" ]; then
    echo "▶ Criando $APP_URLS"
    cat <<EOF > "$APP_URLS"
from django.urls import path
from . import views

urlpatterns = [
    path("", views.index, name="index"),
]
EOF
fi

# Conectar blog.urls ao projeto
PROJECT_URLS="$DJANGO_PROJECT_NAME/urls.py"

echo "▶ Conectando $APP_NAME.urls ao config.urls"

if ! grep -q "include(" "$PROJECT_URLS"; then
    sed -i "1i from django.urls import include" "$PROJECT_URLS"
fi

if ! grep -q "path('', include('$APP_NAME.urls'))" "$PROJECT_URLS"; then
    sed -i "/urlpatterns = \[/a\    path('', include('$APP_NAME.urls'))," "$PROJECT_URLS"
fi

echo
echo "========================================"
echo " App '$APP_NAME' criada e registrada com sucesso 🎉"
echo
echo "Próximos passos:"
echo "  - criar models (Post)"
echo "  - criar views (index, detail, about)"
echo "  - rodar migrations"
echo "========================================"
