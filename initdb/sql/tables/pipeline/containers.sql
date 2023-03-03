CREATE UNLOGGED TABLE IF NOT EXISTS pipeline.containers (
    container_id BIGSERIAL,
    container_token TEXT,
    container_status pipeline.FIELDSETS_CONTAINER_STATUS DEFAULT 'pending'::pipeline.FIELDSETS_CONTAINER_STATUS,
    container_type TEXT,
    event_id BIGINT,
    event_token TEXT,
    meta_data JSONB,
    created TIMESTAMP DEFAULT NOW(),
    updated TIMESTAMPTZ DEFAULT NOW()
) PARTITION BY RANGE (created)
TABLESPACE pipeline;

CREATE UNLOGGED TABLE IF NOT EXISTS pipeline.__containers_current PARTITION OF pipeline.containers DEFAULT
TABLESPACE pipeline;