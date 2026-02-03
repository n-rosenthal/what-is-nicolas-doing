# [`#0002`] Sobre migrações de banco de dados
O modelo de dados inicial `Post` foi definido da seguinte forma:

```python
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
```

É unicamente identificado por sua *slug* e o conteúdo é armazenado em `content`. Queremos migrar este modelo de dados para um que não contenha mais `content`, e contenha os campos `markdown` e `html`.

Para tanto, faremos uma primeira migração para *introdução dos campos `markdown` e `html`*, mantendo o campo `content`. Isto é feito alterando o modelo de dados em `backend/blog/models.py`.

```python
class Post(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(
        max_length=200,
        unique=True,
    )

    content = models.TextField() # legado
    markdown = models.TextField()
    html = models.TextField(editable=False)

    published = models.BooleanField(default=False)
    pinned = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True, editable=False)
    updated_at = models.DateTimeField(auto_now=True, editable=False)
```

Apesar de este ser o segundo Post do blog e ser mais simples apenas deletar o primeiro Post e inserí-lo novamente, nosso intuito é explorar um pouco mais o uso de migrações de banco de dados.

---

## Primeira Migração
Antes de construir a migração e de fato migrar os dados, queremos poder transferir o valor do campo `content` para o campo `markdown`, em todos (sic) os posts do blog.

Para tanto, vamos escrever um *arquivo de migração*. [Os arquivos de migração](https://docs.djangoproject.com/en/6.0/topics/migrations/) são arquivos Python com um layout de objeto pré-estabelecido. Se o formato for adequado para um arquivo de migração, então o arquivo pode ser usado para tal. Em `backend/blog/migrations/`, escreveremos a próxima migração:

```python
#   0007_post_markdown_post_html.py
from django.db import migrations, models

def migrate_content_to_markdown(apps, schema_editor):
    Post = apps.get_model("blog", "Post")
    for post in Post.objects.all():
        post.markdown = post.content
        post.html = ""
        post.save(update_fields=["markdown", "html"])


class Migration(migrations.Migration):
    dependencies = [
        ("blog", "what-is-nicolas-doing/backend/blog/migrations/0006_alter_post_options.py"),
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
        migrations.RunPython(migrate_content_to_markdown),
    ]
```

Nesse primeiro momento, queremos notar que:
1. as *dependencies* são migrações anteriores das quais esta migração depende. Em nosso caso, vamos usar a última migração (`0006`).
2. *operations* são objetos `Operation` que devem ser aplicados na migração. Em nosso caso, queremos apenas executar uma função Python.

> The operations are the key; they are a set of declarative instructions which tell Django what schema changes need to be made. Django scans them and builds an in-memory representation of all of the schema changes to all apps, and uses this to generate the SQL which makes the schema changes.
> [Documentação Django para Migrações](https://docs.djangoproject.com/en/6.0/topics/migrations/)

O que esta migração faz?
1. Insere um novo campo `markdown` ao modelo `Post`. Este campo pode ser tanto nulo quanto uma string vazia.
2. Insere um novo campo `html` ao modelo `Post`. Este campo pode ser nulo. Este campo não é editável, pois quem produz o valor `html` será um renderizador para HTML. Não cabe ao usuário produzir o HTML, e sim ao programa.
3. Executa a função Python `migrate_content_to_markdown`, que preenche o campo `markdown` com o conteúdo do campo `content`, e o campo `html` com uma string vazia.

Existem, também, segredos:

```Python
def reverse_migration(apps, schema_editor):
    Post = apps.get_model("blog", "Post")
    for post in Post.objects.all():
        post.content = post.markdown
        post.save(update_fields=["content"])
```

Sempre que for possível, queremos construir a *migração reversa*, por, pelo menos, dois motivos:

1. se não por possível fazer a *migração para frente* que queremos, então que graciosamente retorne à situação anterior; e
2. se, em algum ponto do futuro, quisermos ir de uma migração posterior de volta para esta, então sabemos por onde ir.

Para permitir a migração reversa, devemos incluí-la como parâmetro ao `RunPython`:

```python
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
            reverse_code=reverse_migration
        ),
    ]
```
O parâmetro `reverse_code` da função `RunPython`,

> The `reverse_code` argument is called when unapplying migrations. This callable should undo what is done in the code callable so that the migration is reversible. If `reverse_code` is `None` (the default), the `RunPython` operation is **irreversible**.
> [Documentação Django para Migrações/RunPython()](https://docs.djangoproject.com/en/6.0/ref/migration-operations/#django.db.migrations.operations.RunPython)


Após escrever a migração, construímos e executamos com os comandos:

```sh
python3 manage.py makemigrations blog
python3 manage.py migrate blog
```

---
## Segunda Migração
Agora, queremos remover o campo legado `content`, pois não será mais utilizado. Escrevemos novamente um arquivo de migração, semelhante ao anterior, ainda que mais simples:

```python
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
```

Executamos novamente os comandos para `makemigrations` e `migrate`, e nosso objetivo é atingido.

---
##      Depois da migração
É necessário atualizar todos os locais que referenciam o modelo `Post` e que fazem uso do legado, e agora inexistente, campo `content`. Isto só pode ocorrer, no momento da nossa aplicação, em uma *View* e no painel de *administração*. 

---