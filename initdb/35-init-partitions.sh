#!/usr/bin/env bash

set -eEa -o pipefail

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CALL fieldsets.create_store_type_partitions('fields', 'fieldsets', '__', 'LIST(type)');
    CREATE TABLE IF NOT EXISTS fieldsets.__default_fields PARTITION OF fieldsets.fields DEFAULT TABLESPACE fieldsets;
    --CALL fieldsets.trigger_05_create_new_date_partition('pipeline', 'logs', 'pipeline');
    --CALL fieldsets.trigger_10_forward_default_partition_data('pipeline', 'logs');
    --CALL fieldsets.trigger_01_set_updated_timestamp('fieldsets', 'config');
EOSQL
