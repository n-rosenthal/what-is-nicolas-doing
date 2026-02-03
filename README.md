#   `what-is-nicolas-doing`
Blog pessoal desenvolvido em Django/Python para registrar estudos, experimentos e projetos pessoais. Este projeto é uma tentativa de armazenar e registrar o que eu venho aprendendo e construindo ao longo das minhas carreiras acadêmica e profissional.

O **objetivo** do projeto é ser um *log* técnico/pessoal focado em estudos em andamento, experimentos técnicos e projetos pessoais. É um blog em Django, exercício de back-end e portifólio para meu início de carreira; 

---
##  tecnologias
- Python (3.12), Django 5 ($+$ templates)
- SQLite ($\to$ PostgreSQL)
- Markdown, HTML, CSS

---
## arquitetura do projeto
```sh
what-is-nicolas-doing/
├── backend/
│   ├── config/
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── blog/
│   │   ├── migrations/
│   │   ├── templates/
│   │   │   └── blog/
│   │   │       ├── index.html
│   │   │       ├── post_detail.html
│   │   │       └── about.html
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── admin.py
│   │   └── urls.py
│   └── manage.py
├── requirements.txt
└── README.md
```

A arquitetura de diretórios do projeto pode ser criada executando

```sh
chmod +x scripts/setup_dirs.sh
./scripts/setup_dirs.sh
```

---
##  inicialização
### *setup* para o projeto Django
Após executar `setup_dirs.sh`, execute

```sh
chmod +x scripts/setup_django.sh
./scripts/setup_django.sh
```

Isto gerará os arquivos necessários para inicializar o projeto Django.

---
### *setup* da aplicação blog

```sh
chmod +x scripts/setup_app_blog.sh
./scripts/setup_app_blog.sh
```

```sh
backend/
├── blog/
│   ├── migrations/
│   ├── templates/
│   │   └── blog/
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── views.py
│   └── urls.py
├── config/
├── manage.py
```

---

# bootstrap `what-is-nicolas-doing`
```bash
setup_dirs.sh       #   arquitetura de diretórios
setup_django.sh     #   cria o projeto Django
setup_app_blog.sh   #   cria o app blog
setup_models.sh     #   modelos de dados para app blog
setup_templates.sh  #   templates para app blog
setup_env.sh        #   config. ambiente de variáveis
```

ou

```sh
./scripts/bootstrap.sh
./scripts/setup_blog_app.sh
./scripts/setup_models.sh
./scripts/setup_templates.sh
./scripts/setup_env.sh
```

O bootstrap.sh é um script orquestrador, responsável apenas por executar os outros scripts na ordem correta. A lógica de *setup* está distribuída em scripts menores e especializados.

# Rodando o projeto
Após o bootstrap, é necessário fazer:

```sh
cd what-is-nicolas-doing
source .venv/bin/activate
cd backend

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver

sudo docker build -t wind .
sudo docker run \
  -p 8000:8000 \
  -e DEBUG=True \
  -e ALLOWED_HOSTS=localhost,127.0.0.1 \
  wind


# Reconstruir tudo
sudo docker-compose down -v
sudo docker-compose up --build

# ou ainda

sudo docker compose down -v
sudo docker compose build --no-cache
sudo docker compose up
```

Então é possível acessar
- blog: `http://127.0.0.1:8000`
- admin: `http://127.0.0.1:8000/admin/`

Nesse momento, já teremos também os arquivos `Procfile` e `runtime.txt` na raiz do projeto.

##  Sobre Docker
Use os comandos conforme necessário, enquanto a aplicação está sendo construída:

```sh
//  ver quanto espaço foi tomado
docker system df

//  limpar contâiners antigos
docker system prune

//  limpar volumes órfãos
docker volume prune
```

##  Sobre Docker Compose
```sh
//  dia-a-dia desenvolvimento
docker compose up --build

//  quando algo dá errado
docker compose down
docker system prune
```

# Deploy
Produção alvo: Railway
Stack final: Django + PostgreSQL (@ Railway), Gunicorn + Whitenoise (static files), Nginx, .env para configuração