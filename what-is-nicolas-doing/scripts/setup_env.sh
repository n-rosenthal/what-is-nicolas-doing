#!/usr/bin/env bash

set -e

PROJECT_NAME="what-is-nicolas-doing"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"
REQUIREMENTS_FILE="$PROJECT_ROOT/requirements.txt"
BACKEND_DIR="$PROJECT_ROOT/$PROJECT_NAME/backend"
SETTINGS_FILE="$BACKEND_DIR/config/settings.py"

echo "========================================"
echo " Setup environment"
echo "========================================"

# Virtualenv
if [ -d "$VENV_DIR" ]; then
  echo "Virtualenv já existe. Pulando criação."
else
  echo "▶ Criando virtualenv"
  python3 -m venv "$VENV_DIR"
fi

echo "▶ Ativando virtualenv"
source "$VENV_DIR/bin/activate"

echo "▶ Atualizando pip"
pip install --upgrade pip

echo "▶ Instalando dependências via requirements.txt"
pip install -r "$REQUIREMENTS_FILE"

# -------------------------------------------------
# settings.py (produção-ready)
# -------------------------------------------------
if ! grep -q "WhitenoiseMiddleware" "$SETTINGS_FILE"; then
  echo "▶ Atualizando settings.py para produção"

  cat <<'EOF' > "$SETTINGS_FILE"
from pathlib import Path
import os

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.environ.get("SECRET_KEY", "unsafe-dev-key")

DEBUG = os.environ.get("DEBUG", "False") == "True"

ALLOWED_HOSTS = os.environ.get("ALLOWED_HOSTS", "").split(",")

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    "blog",
    "markdownify",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ.get("PGDATABASE"),
        "USER": os.environ.get("PGUSER"),
        "PASSWORD": os.environ.get("PGPASSWORD"),
        "HOST": os.environ.get("PGHOST"),
        "PORT": os.environ.get("PGPORT"),
    }
}

LANGUAGE_CODE = "pt-br"
TIME_ZONE = "America/Sao_Paulo"
USE_I18N = True
USE_TZ = True

STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
EOF
fi

# -------------------------------------------------
# Procfile
# -------------------------------------------------
PROCFILE="$PROJECT_ROOT/Procfile"
if [ ! -f "$PROCFILE" ]; then
  echo "▶ Criando Procfile"
  echo "web: gunicorn config.wsgi:application" > "$PROCFILE"
fi

# -------------------------------------------------
# runtime.txt
# -------------------------------------------------
RUNTIME_FILE="$PROJECT_ROOT/runtime.txt"
if [ ! -f "$RUNTIME_FILE" ]; then
  echo "▶ Criando runtime.txt"
  python3 --version | awk '{print "python-"$2}' > "$RUNTIME_FILE"
fi

echo
echo "Ambiente configurado com sucesso 🎉"
echo
echo "Para ativar:"
echo "  source .venv/bin/activate"
