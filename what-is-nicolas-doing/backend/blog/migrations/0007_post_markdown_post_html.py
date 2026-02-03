from django.db import migrations, models


def migrate_content_to_markdown(apps, schema_editor):
    Post = apps.get_model("blog", "Post")
    for post in Post.objects.all():
        post.markdown = post.content
        post.html = ""
        post.save(update_fields=["markdown", "html"])


def reverse_migration(apps, schema_editor):
    Post = apps.get_model("blog", "Post")
    for post in Post.objects.all():
        post.content = post.markdown
        post.save(update_fields=["content"])


class Migration(migrations.Migration):

    dependencies = [
        ("blog", "0006_alter_post_options"),
    ]

    operations = [
        migrations.AddField(
            model_name="post",
            name="markdown",
            field=models.TextField(null=True, blank=True),
        ),
        migrations.AddField(
            model_name="post",
            name="html",
            field=models.TextField(null=True, editable=False),
        ),
        migrations.RunPython(
            migrate_content_to_markdown,
            reverse_code=reverse_migration,
        ),
    ]
