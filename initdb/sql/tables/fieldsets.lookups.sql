/**
 * Lookup Data Store
 * Partitioned on PostgreSQL side for performance.
 * Lookups associate a given fieldset id with another.
 */
CREATE TABLE IF NOT EXISTS fieldsets.lookups (
    id              BIGINT NOT NULL,
    parent          BIGINT NOT NULL,
    field_id        BIGINT NOT NULL,
    type            FIELD_TYPE NOT NULL,
    value           FIELD_VALUE NOT NULL
) PARTITION BY LIST(parent)
TABLESPACE lookups;
