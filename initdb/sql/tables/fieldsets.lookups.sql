/**
 * Lookup Data Store
 * Partitioned on PostgreSQL side for performance.
 * Lookups associate a given fieldset id with another.
 */
CREATE TABLE IF NOT EXISTS fieldsets.lookups (
    id              BIGINT NOT NULL,
    parent          BIGINT NOT NULL,
    lookup_id       BIGINT NOT NULL
)PARTITION BY LIST (parent)
TABLESPACE lookups;
