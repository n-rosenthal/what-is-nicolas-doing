#!/usr/bin/env bash

set -e

PROJECT_NAME="what-is-nicolas-doing"
BACKEND_DIR="$PROJECT_NAME/backend"
APP_NAME="blog"
TEMPLATES_DIR="$BACKEND_DIR/$APP_NAME/templates/$APP_NAME"

echo "========================================"
echo " Setup templates: blog"
echo "========================================"

if [ ! -d "$TEMPLATES_DIR" ]; then
  echo "Erro: diretório de templates não existe. Execute setup_blog_app.sh primeiro."
  exit 1
fi

echo "▶ Criando templates"

cat <<EOF > "$TEMPLATES_DIR/index.html"
<!DOCTYPE html>
<html>
<head>
    <title>O que o Nícolas tem feito?</title>
</head>
<body>
    <h1>O que o Nícolas tem feito?</h1>

    <ul>
        {% for post in posts %}
            <li>
                <a href="{% url 'post_detail' post.slug %}">
                    {{ post.title }}
                </a>
                <small>{{ post.created_at }}</small>
            </li>
        {% empty %}
            <li>Nenhum post publicado ainda.</li>
        {% endfor %}
    </ul>
</body>
</html>
EOF

cat <<EOF > "$TEMPLATES_DIR/post_detail.html"
<!DOCTYPE html>
<html>
<head>
    <title>{{ post.title }}</title>
</head>
<body>
    <h1>{{ post.title }}</h1>
    <small>{{ post.created_at }}</small>

    <hr>

    {{ post.content|linebreaks }}
</body>
</html>
EOF

cat <<EOF > "$TEMPLATES_DIR/about.html"
<!DOCTYPE html>
<html>
<head>
    <title>Sobre</title>
</head>
<body>
    <h1>Sobre</h1>

    <p>
        Blog pessoal de Nícolas Rosenthal para registrar estudos,
        projetos e experimentos em computação.
    </p>
</body>
</html>
EOF

echo
echo "Templates criados com sucesso 🎉"
