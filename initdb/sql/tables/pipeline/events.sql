CREATE UNLOGGED TABLE IF NOT EXISTS pipeline.events (
    event_token TEXT,
    created TIMESTAMP DEFAULT NOW(),
    meta_data JSONB,
	event_id BIGSERIAL,
	pipeline TEXT DEFAULT 'all',
    event_status pipeline.FIELDSETS_EVENT_STATUS DEFAULT 'pending'::pipeline.FIELDSETS_EVENT_STATUS,
    updated TIMESTAMPTZ DEFAULT NOW()
) PARTITION BY RANGE (created)
TABLESPACE pipeline;

CREATE UNLOGGED TABLE IF NOT EXISTS pipeline.__events_current PARTITION OF pipeline.events DEFAULT
TABLESPACE pipeline;