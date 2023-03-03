#!/usr/bin/env bash

set -eEa -o pipefail
# Create our data tables and relational architecture.

for f in /docker-entrypoint-initdb.d/sql/tables/*.sql; do
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done 

# Only create local events and container tables if we are not using a remote events server.
# Otherise we create foreign tables after Postgres has been provisioned.
if [[ "${EVENTS_HOST}" == "${POSTGRES_HOST}" ]]; then
	for f in /docker-entrypoint-initdb.d/sql/tables/pipeline/*.sql; do
		psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
	done 
fi