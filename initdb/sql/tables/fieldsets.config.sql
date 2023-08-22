CREATE TABLE fieldsets.config (
	config_id SERIAL UNIQUE NOT NULL,
	config_token VARCHAR(255) UNIQUE NOT NULL,
    config_data JSONB,
    created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
);