/**
 * Token Lookup
 * Partitioned on PostgreSQL side for performance.
 * Lookups associate a given fieldset id with another.
 */
CREATE TABLE IF NOT EXISTS fieldsets.tokens (
    id              BIGINT NOT NULL UNIQUE,
    token           TEXT NOT NULL,
    CONSTRAINT tokens_pk PRIMARY KEY(id)
) PARTITION BY HASH(id)
TABLESPACE fieldsets;

--TODO: Implement this a a stored procedure that generates the partition numbers via environment variable.
CREATE TABLE IF NOT EXISTS fieldsets.__tokens_part1 PARTITION OF fieldsets.tokens
FOR VALUES WITH (MODULUS 5, REMAINDER 0)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_part2 PARTITION OF fieldsets.tokens
FOR VALUES WITH (MODULUS 5, REMAINDER 1)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_part3 PARTITION OF fieldsets.tokens
FOR VALUES WITH (MODULUS 5, REMAINDER 2)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_part4 PARTITION OF fieldsets.tokens
FOR VALUES WITH (MODULUS 5, REMAINDER 3)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_part5 PARTITION OF fieldsets.tokens
FOR VALUES WITH (MODULUS 5, REMAINDER 4)
TABLESPACE fieldsets;
