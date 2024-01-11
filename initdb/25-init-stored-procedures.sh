#!/usr/bin/env bash

set -eEa -o pipefail

for f in /docker-entrypoint-initdb.d/sql/stored_procedures/*.sql; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done
