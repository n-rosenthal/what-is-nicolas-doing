"""
    `what-is-nicolas-doing/backend/blog/views.py`
    
    Views para o blog:
    
    - `index`:           Renderiza a página de entrada do blog.
    - `post_detail`:     Renderiza uma página de detalhe de um post.
"""
from django.shortcuts import render, get_object_or_404
from .models import Post


def index(request):
    """
    Renderiza a página de entrada do blog.

    Esta página lista todos os posts publicados, ordenados por data de criação
    (mais recentes primeiro) e pela marcação de "pinned" (posts fixados no topo
    da lista aparecem primeiro).

    O template utilizado é blog/index.html e utiliza o objeto "posts" para
    renderizar a lista de posts.
    """
    posts = (
        Post.objects
        .filter(published=True)
        .order_by("-pinned", "-created_at")
    )
    return render(request, "blog/index.html", {"posts": posts})


def post_detail(request, slug):
    """
    Renderiza uma página de detalhe de um post.

    Este view utiliza o modelo Post para buscar um post com o slug especificado.
    Se o post não existir ou não estiver publicado, lança um 404.
    O template utilizado é blog/post_detail.html e utiliza o objeto post para renderizar o conteúdo do post.
    """
    post = get_object_or_404(Post, slug=slug, published=True)

    previous_post = (
        Post.objects.filter(
            published=True,
            created_at__lt=post.created_at
        )
        .order_by("-created_at")
        .first()
    )

    next_post = (
        Post.objects.filter(
            published=True,
            created_at__gt=post.created_at
        )
        .order_by("created_at")
        .first()
    )

    related_posts = (
        Post.objects
        .filter(published=True)
        .exclude(id=post.id)[:3]
    )

    return render(request, "blog/post_detail.html", {
        "post": post,
        "previous_post": previous_post,
        "next_post": next_post,
        "related_posts": related_posts,
    })
