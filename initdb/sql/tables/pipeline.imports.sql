/**
 * This imports table is a simple table that contains only an indexed JSONB column so we can easily import and query any json schemas.
 */
CREATE TABLE IF NOT EXISTS pipeline.imports(
    token TEXT NULL,
    source TEXT NULL,
    type TEXT NULL,
    priority INT NULL,
    data JSONB NULL,
    imported BOOLEAN DEFAULT FALSE,
    created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY LIST(imported)
TABLESPACE pipeline;

CREATE TABLE IF NOT EXISTS pipeline.__imports_complete PARTITION OF pipeline.imports
FOR VALUES IN (TRUE)
PARTITION BY LIST(token)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS pipeline.__imports_default PARTITION OF pipeline.imports DEFAULT
TABLESPACE fieldsets;
