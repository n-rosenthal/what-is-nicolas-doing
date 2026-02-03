# Dockerfile
FROM python:3.10-slim

# Evita bytecode e buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Diretório de trabalho
WORKDIR /what-is-nicolas-doing

# Dependências do sistema
RUN apt-get update \
    && apt-get install -y build-essential libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Código
COPY . .

# Staticfiles (coletados no runtime também, mas isto ajuda no cache)
RUN python manage.py collectstatic --noinput || true

# Porta padrão
EXPOSE 8000

# Comando de execução
WORKDIR /what-is-nicolas-doing/backend
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]
