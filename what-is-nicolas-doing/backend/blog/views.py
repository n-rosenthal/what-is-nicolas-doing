# views.py
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
    post = get_object_or_404(
        Post,
        slug=slug,
        published=True,
    )

    context = {
        "post": post,
        # o template usa {{ post.html|safe }}
    }

    return render(request, "blog/post_detail.html", context)
