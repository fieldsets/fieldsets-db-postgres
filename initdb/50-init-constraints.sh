#!/usr/bin/env bash

set -eEa -o pipefail

echo "Creating constraints...."

for f in /docker-entrypoint-initdb.d/sql/constraints/primary_keys/*.sql; do
	psql -v ON_ERROR_STOP=0 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
	PIDS+=(${!});
done

for f in /docker-entrypoint-initdb.d/sql/indexes/*.sql; do
	psql -v ON_ERROR_STOP=0 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done

for f in /docker-entrypoint-initdb.d/sql/constraints/foreign_keys/*.sql; do
	psql -v ON_ERROR_STOP=0 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done

echo "Constraints created.";
