#!/usr/bin/env bash

set -eEa -o pipefail

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_none PARTITION OF fieldsets.fieldsets FOR VALUES IN (0) PARTITION BY LIST(store) TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_fieldset PARTITION OF fieldsets.fieldsets FOR VALUES IN (1) PARTITION BY LIST(store) TABLESPACE fieldsets;
    CALL fieldsets.create_store_partitions('__fieldsets_none','none','fieldsets');
    CALL fieldsets.create_store_partitions('__fieldsets_fieldset','fieldset','fieldsets');
EOSQL
