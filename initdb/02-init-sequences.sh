#!/usr/bin/env bash

set -eEa -o pipefail

# TODO: Break out into individual sql files for easier reading & use.
# Create our data tables and relational architecture.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	-- Add in any manual sequences here.
EOSQL