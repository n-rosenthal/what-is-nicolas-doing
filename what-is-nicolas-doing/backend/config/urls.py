"""
    `what-is-nicolas-doing/backend/config/urls.py`
    
    URLs para o projeto Django:
    
    - `/admin/` : Admin Django.
    - `/blog/`  : URLs para o blog.
"""

from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("blog/", include("blog.urls")),
]
