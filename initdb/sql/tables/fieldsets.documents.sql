/**
 * Document Data Store
 * Use Postgresql with JSONB column.
 * @TODO: Integrate MongoDB Option
 */
CREATE TABLE IF NOT EXISTS fieldsets.documents (
    id          BIGINT NOT NULL,
    parent      BIGINT NOT NULL,
    document    JSONB NOT NULL DEFAULT '{}'::JSONB,
    created     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated     TIMESTAMPTZ NOT NULL DEFAULT NOW()
)
TABLESPACE documents;
