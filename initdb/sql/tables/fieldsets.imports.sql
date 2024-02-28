/**
 * This imports table is a simple table that contains only an indexed JSONB column so we can easily import and query any json schemas.
 */
CREATE TABLE IF NOT EXISTS fieldsets.imports(
    token TEXT NULL,
    source TEXT NULL,
    type TEXT NULL,
    order INT NULL,
    data JSONB NULL
)
TABLESPACE fieldsets;