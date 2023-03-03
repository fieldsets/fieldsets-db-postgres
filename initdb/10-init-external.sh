#!/usr/bin/env bash

set -eEa -o pipefail

# Instantiate our Foreign Data Wrappers
# Additiona FDW extensions can be loaded here.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"  <<-EOSQL
    SET search_path TO 'public';
    CREATE EXTENSION IF NOT EXISTS postgres_fdw;
    CREATE EXTENSION IF NOT EXISTS clickhouse_fdw;
EOSQL
