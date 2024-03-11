/**
 * Message Data Store.
 */
CREATE TABLE IF NOT EXISTS fieldsets.messages (
    id         	    BIGINT NOT NULL,
    parent     	    BIGINT NULL DEFAULT 0,
    field_id        BIGINT NULL,
    message         TEXT NULL,
    created         TIMESTAMPTZ NOT NULL DEFAULT NOW()
) TABLESPACE messages;