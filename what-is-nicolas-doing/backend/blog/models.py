"""
    `what-is-nicolas-doing/backend/blog/models.py`
    
    Model para o blog - COM MAIS CONTROLE
"""

from django.db import models
from django.utils.text import slugify

from django.db import models


class Post(models.Model):
    title = models.CharField(max_length=200)

    slug = models.SlugField(
        max_length=200,
        unique=True,
    )

    content = models.TextField()

    published = models.BooleanField(default=False)
    pinned = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True, editable=False)
    updated_at = models.DateTimeField(auto_now=True, editable=False)

    def __str__(self):
        return self.title
