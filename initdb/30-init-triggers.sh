#!/usr/bin/env bash

set -eEa -o pipefail

for f in /docker-entrypoint-initdb.d/sql/triggers/*.sql; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CALL public.trigger_01_set_updated_timestamp('pipeline', 'config');
    CALL public.trigger_05_create_new_date_partition('pipeline', 'logs', 'pipeline');
    CALL public.trigger_10_forward_default_partition_data('pipeline', 'logs');
EOSQL

