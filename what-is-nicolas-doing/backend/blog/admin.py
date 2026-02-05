"""
    `what-is-nicolas-doing/backend/blog/admin.py`
    
    Admin Django para a aplicação Blog.
"""
from django.contrib import admin
from django.utils.safestring import mark_safe
from django.utils.text import slugify
from .models import Post


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    """Admin Django para o model Post."""
    list_display = ("title", "published", "pinned", "created_at")
    list_filter = ("published", "pinned")
    search_fields = ("title", "markdown")

    readonly_fields = ("html_preview", "created_at", "updated_at")

    fieldsets = (
        ("Sobre o post", {
            "fields": ("title", "slug", "published", "pinned")
        }),
        ("Conteúdo (Markdown)", {
            "fields": ("markdown", "html_preview")
        }),
        ("Metadados", {
            "fields": ("created_at", "updated_at"),
            "classes": ("collapse",),
        }),
    )

    def html_preview(self, obj):
        """
        Retorna uma preview do HTML renderizado do conteúdo do post.

        Se o post ainda não tiver sido salvo, retorna uma mensagem
        indicando que o post precisa ser salvo antes de ver a preview.
        """
        if not obj.pk:
            return "Salve o post para ver o preview."
        return mark_safe(obj.html)

    html_preview.short_description = "Preview (HTML renderizado)"

    def save_model(self, request, obj, form, change):
        """
        Salva o modelo Post. Se o campo slug estiver vazio,
        preenche-o com o valor do campo title slugificado.
        """
        if not obj.slug:
            obj.slug = slugify(obj.title)
        super().save_model(request, obj, form, change)
