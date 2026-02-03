# blog/feeds.py
from django.contrib.syndication.views import Feed
from .models import Post

class LatestPostsFeed(Feed):
    title = "what-is-nicolas-doing"
    link = "/blog/"
    description = "Postagens recentes"

    def items(self):
        return Post.objects.filter(published=True)[:10]

    def item_title(self, item):
        return item.title

    def item_description(self, item):
        return item.html
