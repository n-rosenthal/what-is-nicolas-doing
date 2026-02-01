# what-is-nicolas-doing/scripts/wait-for-db.sh
#!/bin/bash
# Aguarda o PostgreSQL estar pronto

set -e

host="$1"
shift
cmd="$@"

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$host" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q'; do
    >&2 echo "PostgreSQL não está disponível - aguardando..."
    sleep 2
done

>&2 echo "PostgreSQL está disponível - executando comando"
exec $cmd