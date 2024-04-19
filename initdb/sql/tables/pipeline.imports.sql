/**
 * This imports table is a simple table that contains only an indexed JSONB column so we can easily import and query any json schemas.
 */
CREATE TABLE IF NOT EXISTS pipeline.imports(
    token TEXT NULL,
    source TEXT NULL,
    type TEXT NULL,
    priority INT NULL,
    data JSONB NULL,
    imported BOOLEAN DEFAULT FALSE
)
TABLESPACE pipeline;