#!/usr/bin/env bash

set -eEa -o pipefail

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CALL fieldsets.create_fields_partitions('fields', 'fieldsets', 0);
    CREATE TABLE IF NOT EXISTS fieldsets.__fields_default PARTITION OF fieldsets.fields DEFAULT TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__sets_none PARTITION OF fieldsets.sets FOR VALUES IN (0) TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__sets_fieldset PARTITION OF fieldsets.sets FOR VALUES IN (1) TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_none PARTITION OF fieldsets.fieldsets FOR VALUES IN (0) PARTITION BY LIST(parent) TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_fieldset PARTITION OF fieldsets.fieldsets FOR VALUES IN (1) PARTITION BY LIST(parent) TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_none_default PARTITION OF fieldsets.__fieldsets_none FOR VALUES IN (0) PARTITION BY LIST(store) TABLESPACE fieldsets;
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_fieldset_default PARTITION OF fieldsets.__fieldsets_fieldset FOR VALUES IN (1) PARTITION BY LIST(store) TABLESPACE fieldsets;
    CALL fieldsets.create_fields_partitions('__fieldsets_none_default', 'fieldsets', 0);
    CALL fieldsets.create_fields_partitions('__fieldsets_fieldset_default', 'fieldsets', 0);
    CREATE TABLE IF NOT EXISTS fieldsets.__fieldsets_default PARTITION OF fieldsets.fieldsets DEFAULT TABLESPACE fieldsets;
EOSQL
