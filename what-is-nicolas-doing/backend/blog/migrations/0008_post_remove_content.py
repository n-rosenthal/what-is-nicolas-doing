from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("blog", "0007_post_markdown_post_html"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="post",
            name="content",
        ),
    ]