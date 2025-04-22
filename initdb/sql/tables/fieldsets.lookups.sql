/**
 * Lookup Data Store
 * Partitioned on PostgreSQL side for performance.
 * Lookups associate a given fieldset id with a value.
 * Values are indexed and relationships can be 1 to 1, 1 to many or many to 1
 */
CREATE TABLE IF NOT EXISTS fieldsets.lookups (
    id              BIGINT NOT NULL,
    parent          BIGINT NOT NULL,
    value           FIELD_VALUE NOT NULL,
    created         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated         TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY LIST(parent)
TABLESPACE lookups;
