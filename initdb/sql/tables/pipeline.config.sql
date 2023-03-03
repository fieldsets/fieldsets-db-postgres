-- public.config definition

-- Drop table

-- DROP TABLE public.config;

CREATE TABLE pipeline.config (
	config_id SERIAL UNIQUE NOT NULL,
	config_token TEXT NOT NULL,
    config_data JSONB,
    created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
);