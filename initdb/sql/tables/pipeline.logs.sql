CREATE UNLOGGED TABLE IF NOT EXISTS pipeline.logs (
	tag TEXT NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    meta_data JSONB
) PARTITION BY RANGE (created)
TABLESPACE pipeline;

CREATE UNLOGGED TABLE IF NOT EXISTS pipeline.__logs_default PARTITION OF pipeline.logs DEFAULT
TABLESPACE pipeline;