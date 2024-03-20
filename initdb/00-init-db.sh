#!/usr/bin/env bash

#===
# 00-init-db.sh: Wrapper script for the setting up schemas, users and data types for fieldsets
# @priority 0
# @envvar POSTGRES_* | String (All `POSTGRES_` prefixed variables should be populated) 
#
#===

set -eEa -o pipefail

#===
# Variables
#===

#===
# Functions
#===

##
# traperr: Better error handling
##
traperr() {
  echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

##
# create_schemas: Create DB schemas
##
create_schemas() {

    mkdir -p /var/lib/postgresql/pipeline
    mkdir -p /var/lib/postgresql/fieldsets
    mkdir -p /var/lib/postgresql/plugins
    mkdir -p /var/lib/postgresql/documents
    mkdir -p /var/lib/postgresql/filters
    mkdir -p /var/lib/postgresql/lookups
    mkdir -p /var/lib/postgresql/streams
    mkdir -p /var/lib/postgresql/records
    mkdir -p /var/lib/postgresql/sequences

    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE SCHEMA IF NOT EXISTS fieldsets;
        CREATE SCHEMA IF NOT EXISTS pipeline;

        CREATE EXTENSION IF NOT EXISTS pg_cron;

        CREATE TABLESPACE pipeline  LOCATION '/var/lib/postgresql/pipeline';
        CREATE TABLESPACE fieldsets LOCATION '/var/lib/postgresql/fieldsets';

        -- Create tablespaces for PG based stores. This allows you to mount separate volumes and disk types for a store type.
        CREATE TABLESPACE plugins LOCATION '/var/lib/postgresql/plugins';
        CREATE TABLESPACE documents LOCATION '/var/lib/postgresql/documents';
        CREATE TABLESPACE filters LOCATION '/var/lib/postgresql/filters';
        CREATE TABLESPACE lookups LOCATION '/var/lib/postgresql/lookups';
        CREATE TABLESPACE streams LOCATION '/var/lib/postgresql/streams';
        CREATE TABLESPACE records LOCATION '/var/lib/postgresql/records';
        CREATE TABLESPACE sequences LOCATION '/var/lib/postgresql/sequences';
	EOSQL
}

##
# create_data_types: Create DB custom data types
##
create_data_types() {
    for f in /docker-entrypoint-initdb.d/sql/data_types/*.sql; do
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
    done 
}

##
# create_roles: Create DB roles
##
create_roles() {
    # Make sure we don't set empty passwords. Use the global account password for roles.
    if [[ -z "${POSTGRES_READER_ROLE_PASSWORD}" ]]; then
        POSTGRES_READER_ROLE_PASSWORD=${POSTGRES_PASSWORD}
    fi
    if [[ -z "${POSTGRES_WRITER_ROLE_PASSWORD}" ]]; then
        POSTGRES_WRITER_ROLE_PASSWORD=${POSTGRES_PASSWORD}
    fi
    if [[ -z "${POSTGRES_TRIGGER_ROLE_PASSWORD}" ]]; then
        POSTGRES_TRIGGER_ROLE_PASSWORD=${POSTGRES_PASSWORD}
    fi
    echo "Creating Roles...."
    local user_sql="--Check if user & roles exist
    DO \$\$ DECLARE
        role_exists BOOLEAN;
    BEGIN
        SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_roles WHERE rolname='${POSTGRES_READER_ROLE}') INTO role_exists;
        IF NOT role_exists THEN
            EXECUTE format('CREATE ROLE ${POSTGRES_READER_ROLE} LOGIN PASSWORD %L INHERIT', '${POSTGRES_READER_ROLE_PASSWORD}');
        END IF;

        SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_roles WHERE rolname='${POSTGRES_WRITER_ROLE}') INTO role_exists;
        IF NOT role_exists THEN
            EXECUTE format('CREATE ROLE ${POSTGRES_WRITER_ROLE} LOGIN PASSWORD %L INHERIT', '${POSTGRES_WRITER_ROLE_PASSWORD}');
        END IF;

        SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_roles WHERE rolname='${POSTGRES_TRIGGER_ROLE}') INTO role_exists;
        IF NOT role_exists THEN
            EXECUTE format('CREATE ROLE ${POSTGRES_TRIGGER_ROLE} SUPERUSER LOGIN PASSWORD %L INHERIT', '${POSTGRES_TRIGGER_ROLE_PASSWORD}');
            EXECUTE 'GRANT pg_read_server_files, pg_write_server_files, pg_execute_server_program, pg_signal_backend TO ${POSTGRES_TRIGGER_ROLE}';
        END IF;

        EXECUTE 'GRANT CONNECT, TEMPORARY ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_READER_ROLE}, ${POSTGRES_WRITER_ROLE}';

        EXECUTE 'GRANT USAGE ON SCHEMA public TO ${POSTGRES_READER_ROLE}, ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA public TO ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${POSTGRES_WRITER_ROLE}';

        EXECUTE 'GRANT USAGE ON SCHEMA fieldsets TO ${POSTGRES_READER_ROLE}, ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA fieldsets TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA fieldsets TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT EXECUTE ON ALL ROUTINES IN SCHEMA fieldsets TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA fieldsets TO ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA fieldsets TO ${POSTGRES_WRITER_ROLE}';

        EXECUTE 'GRANT USAGE ON SCHEMA cron TO ${POSTGRES_READER_ROLE}, ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA cron TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA cron TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT EXECUTE ON ALL ROUTINES IN SCHEMA cron TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cron TO ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA cron TO ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA cron TO ${POSTGRES_WRITER_ROLE}';

        EXECUTE 'GRANT USAGE ON SCHEMA pipeline TO ${POSTGRES_READER_ROLE}, ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA pipeline TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA pipeline TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT EXECUTE ON ALL ROUTINES IN SCHEMA pipeline TO ${POSTGRES_READER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pipeline TO ${POSTGRES_WRITER_ROLE}';
        EXECUTE 'GRANT ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA pipeline TO ${POSTGRES_WRITER_ROLE}';

        EXECUTE 'ALTER ROLE ${POSTGRES_TRIGGER_ROLE} SET synchronous_commit=OFF';

    END \$\$;"
    psql -v ON_ERROR_STOP=1 --port "$POSTGRES_PORT" --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "${user_sql}"
    echo "Roles Created."
}

##
# init: Initialize DB
##
init() {
    # Create schemas, accounts ENUMs etc.
    echo "Initializing DB...."
    create_schemas
    create_data_types
    create_roles
    echo "DB Initialized."
}

#===
# Main
#===
init

trap '' 2 3
trap traperr ERR