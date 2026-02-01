#!/usr/bin/env bash

set -e

PROJECT_NAME="what-is-nicolas-doing"
BACKEND_DIR="$PROJECT_NAME/backend"
APP_NAME="blog"

MODELS_FILE="$BACKEND_DIR/$APP_NAME/models.py"
ADMIN_FILE="$BACKEND_DIR/$APP_NAME/admin.py"

echo "========================================"
echo " Setup models: Post"
echo "========================================"

if [ ! -f "$BACKEND_DIR/manage.py" ]; then
  echo "Erro: projeto Django não inicializado."
  exit 1
fi

if grep -q "class Post" "$MODELS_FILE"; then
  echo "Model Post já existe. Abortando."
  exit 1
fi

echo "▶ Criando model Post"

cat <<EOF > "$MODELS_FILE"
from django.db import models
from django.utils.text import slugify

class Post(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True, blank=True)
    content = models.TextField(help_text="Markdown content")
    created_at = models.DateField(auto_now_add=True)
    published = models.BooleanField(default=True)

    class Meta:
        ordering = ["-created_at"]

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.title
EOF

echo "▶ Registrando Post no admin"

cat <<EOF > "$ADMIN_FILE"
from django.contrib import admin
from .models import Post

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ("title", "created_at", "published")
    list_filter = ("published",)
    prepopulated_fields = {"slug": ("title",)}
EOF

echo
echo "Model Post criado e registrado com sucesso 🎉"
echo "Próximos passos:"
echo "  python manage.py makemigrations"
echo "  python manage.py migrate"
