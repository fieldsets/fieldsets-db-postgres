#!/usr/bin/env bash

set -eEa -o pipefail

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"  <<-EOSQL
    -- INSERT INTO public.analysis_pipeline (analysis_pipeline_id,analysis_pipeline_name) VALUES
    --   (1,'fieldsetsga'),
    --    (2,'genie') ON CONFLICT DO NOTHING;
EOSQL



