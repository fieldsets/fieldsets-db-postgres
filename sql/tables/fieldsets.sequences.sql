/**
 * Position based Data Store
 * Should use tradional Columnar table.
 */
CREATE TABLE IF NOT EXISTS fieldsets.sequences(
    id          BIGINT NOT NULL,
    parent      BIGINT NULL DEFAULT 0,
    position    BIGINT NULL
) TABLESPACE sequences;

