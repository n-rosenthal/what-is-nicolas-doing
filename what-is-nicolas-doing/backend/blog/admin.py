from django.contrib import admin
from django.utils.safestring import mark_safe
from .models import Post
import markdown


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ("title", "published", "pinned", "created_at")
    list_filter = ("published", "pinned")
    search_fields = ("title", "content")

    readonly_fields = ("markdown_preview", "created_at", "updated_at")

    fieldsets = (
        ("Sobre o post", {
            "fields": ("title", "published", "pinned")
        }),
        ("Conteúdo", {
            "fields": ("content", "markdown_preview")
        }),
        ("Metadados", {
            "fields": ("created_at", "updated_at"),
            "classes": ("collapse",),
        }),
    )

    def markdown_preview(self, obj):
        if not obj.pk:
            return "Salve o post para ver o preview."
        return mark_safe(
            markdown.markdown(obj.content, extensions=["fenced_code", "codehilite"])
        )

    markdown_preview.short_description = "Preview (Markdown)"

    def save_model(self, request, obj, form, change):
        if not obj.slug:
            from django.utils.text import slugify
            obj.slug = slugify(obj.title)
        super().save_model(request, obj, form, change)
