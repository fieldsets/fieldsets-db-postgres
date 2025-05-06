/**
 * Enumerate Field Type Tokens
 */
CREATE TABLE IF NOT EXISTS fieldsets.enums (
    id             BIGINT NOT NULL,
    token          TEXT NOT NULL,
    field_id       BIGINT NOT NULL,
    field_token    TEXT NOT NULL,
    created        TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY LIST(field_id)
TABLESPACE fieldsets;