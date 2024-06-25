/**
 * Token Lookup
 * Partitioned on PostgreSQL side for performance.
 * Lookups associate a given fieldset id with another.
 */
CREATE TABLE IF NOT EXISTS fieldsets.tokens (
    id              BIGINT NOT NULL UNIQUE,
    token           TEXT NOT NULL UNIQUE,
    CONSTRAINT tokens_pk PRIMARY KEY(id)
) TABLESPACE fieldsets;