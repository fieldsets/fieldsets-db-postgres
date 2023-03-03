#!/usr/bin/env bash

set -eEa -o pipefail

for f in /docker-entrypoint-initdb.d/sql/triggers/*.sql; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CALL pipeline.trigger_01_set_updated_timestamp('pipeline', 'config');
    CALL pipeline.trigger_05_create_new_date_partition('pipeline', 'logs', 'pipeline');
    CALL pipeline.trigger_10_forward_default_partition_data('pipeline', 'logs');
EOSQL

# Only create local events and container table partitions if we are not using a remote events server.
# Otherise we create foreign tables after Postgres has been provisioned.
if [[ "${EVENTS_HOST}" == "${POSTGRES_HOST}" ]]; then
	for f in /docker-entrypoint-initdb.d/sql/triggers/pipeline/*.sql; do
		psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
	done 
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
		CALL pipeline.trigger_00_register_event('__events_current');
		CALL pipeline.trigger_01_set_updated_timestamp('pipeline', '__events_current');
		CALL pipeline.trigger_01_set_updated_timestamp('pipeline', '__containers_current');
		CALL pipeline.trigger_05_create_new_date_partition('pipeline', 'events', 'pipeline');
		CALL pipeline.trigger_05_create_new_date_partition('pipeline', 'containers', 'pipeline');
		CALL pipeline.trigger_10_forward_default_partition_data('pipeline', 'events');
		CALL pipeline.trigger_10_forward_default_partition_data('pipeline', 'containers');
	EOSQL
fi

