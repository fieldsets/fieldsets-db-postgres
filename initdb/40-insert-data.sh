#!/usr/bin/env bash

set -eEa -o pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"  <<-EOSQL
    -- INSERT INTO public.sample_table (id,name) VALUES
    --   (1,'fieldsets'),
EOSQL



