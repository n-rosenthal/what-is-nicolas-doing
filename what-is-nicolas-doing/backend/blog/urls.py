"""
    `what-is-nicolas-doing/backend/blog/urls.py`
    
    URLs para o blog:
    
    - `/`:              Renderiza a página de entrada do blog.
    - `<slug:slug>/`:   Renderiza uma página de detalhe de um post.
"""
from django.urls import path
from . import views

app_name = "blog"

urlpatterns = [
    path("", views.index, name="index"),
    path("<slug:slug>/", views.post_detail, name="post_detail"),
]