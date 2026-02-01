from django.shortcuts import render, get_object_or_404
from .models import Post
import markdown

def index(request):
    posts = Post.objects.order_by("-created_at")
    return render(request, "blog/index.html", {"posts": posts})


def post_detail(request, slug):
    post = get_object_or_404(
        Post,
        slug=slug,
        published=True,
    )

    html_content = markdown.markdown(
        post.content,
        extensions=["fenced_code", "codehilite"]
    )

    context = {
        "post": post,
        "content": html_content,
    }

    return render(request, "blog/post_detail.html", context)

def post_list(request):
    posts = (Post.objects
        .filter(published=True)
        .order_by("-pinned", "-created_at")
    )

    context = {
        "posts": posts,
    }

    return render(request, "blog/index.html", context)
