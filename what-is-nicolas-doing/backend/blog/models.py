"""
    `what-is-nicolas-doing/backend/blog/models.py`
    
    Definição dos modelos de dados para o blog.
    
    `Post` é a representação de uma postagem no blog.
"""

from django.db import models
from django.utils.text import slugify
from django.urls import reverse

from .markdown.renderer import render_markdown

def get_absolute_url(self):
    return reverse("blog:post_detail", args=[self.slug])


class Post(models.Model):
    title = models.CharField(max_length=200)

    slug = models.SlugField(
        max_length=200,
        unique=True,
    )

    markdown = models.TextField(null=True, blank=True)
    html = models.TextField(null=True, editable=False)

    published = models.BooleanField(default=False)
    pinned = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True, editable=False)
    updated_at = models.DateTimeField(auto_now=True, editable=False)

    def __str__(self):
        return self.title
    
    
    def save(self, *args, **kwargs):
        self.html = render_markdown(self.markdown)
        super().save(*args, **kwargs)
