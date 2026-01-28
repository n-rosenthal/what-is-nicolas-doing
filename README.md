#   `what-is-nicolas-doing`
Blog pessoal desenvolvido em Django/Python para registrar estudos, experimentos e projetos pessoais. Este projeto é uma tentativa de armazenar e registrar o que eu venho aprendendo e construindo ao longo das minhas carreiras acadêmica e profissional.

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
