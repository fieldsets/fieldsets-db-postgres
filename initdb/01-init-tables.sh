#!/usr/bin/env bash

set -eEa -o pipefail
# Create our data tables and relational architecture.

for f in /docker-entrypoint-initdb.d/sql/tables/*.sql; do
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done 
