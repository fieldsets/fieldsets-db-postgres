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


# Only create local events and container table partitions if we are not using a remote events server.
# Otherise we create foreign tables after Postgres has been provisioned.
if [[ "${EVENTS_HOST}" == "${POSTGRES_HOST}" ]]; then
	for f in /docker-entrypoint-initdb.d/sql/constraints/primary_keys/pipeline/*.sql; do
		psql -v ON_ERROR_STOP=0 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
		PIDS+=(${!});
	done
	for f in /docker-entrypoint-initdb.d/sql/indexes/pipeline/*.sql; do
		psql -v ON_ERROR_STOP=0 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
	done
fi

echo "Constraints created.";
