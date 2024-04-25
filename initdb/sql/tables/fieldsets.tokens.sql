/**
 * Token Lookup
 * Partitioned on PostgreSQL side for performance.
 * Lookups associate a given fieldset id with another.
 */
CREATE TABLE IF NOT EXISTS fieldsets.tokens (
    id              BIGINT NOT NULL,
    token           TEXT NOT NULL
) PARTITION BY RANGE (token)
TABLESPACE fieldsets;

/*
CREATE TABLE IF NOT EXISTS fieldsets.__tokens_a PARTITION OF fieldsets.tokens
FOR VALUES FROM ('a') TO ('b')
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_b PARTITION OF fieldsets.tokens
FOR VALUES FROM ('b') TO ('c')
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_c PARTITION OF fieldsets.tokens
FOR VALUES FROM ('c') TO ('d')
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_d PARTITION OF fieldsets.tokens
FOR VALUES FROM ('d') TO ('e')
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_e PARTITION OF fieldsets.tokens
FOR VALUES FROM ('e') TO ('f')
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_f PARTITION OF fieldsets.tokens
FOR VALUES FROM ('f') TO ('g')
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_g PARTITION OF fieldsets.tokens
FOR VALUES FROM ('g') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_h PARTITION OF fieldsets.tokens
FOR VALUES FROM ('h') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_i PARTITION OF fieldsets.tokens
FOR VALUES FROM ('i') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_j PARTITION OF fieldsets.tokens
FOR VALUES FROM ('j') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_k PARTITION OF fieldsets.tokens
FOR VALUES FROM ('k') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_l PARTITION OF fieldsets.tokens
FOR VALUES FROM ('l') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_m PARTITION OF fieldsets.tokens
FOR VALUES FROM ('m') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_n PARTITION OF fieldsets.tokens
FOR VALUES FROM ('n') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_o PARTITION OF fieldsets.tokens
FOR VALUES FROM ('o') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_p PARTITION OF fieldsets.tokens
FOR VALUES FROM ('p') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_q PARTITION OF fieldsets.tokens
FOR VALUES FROM ('q') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_r PARTITION OF fieldsets.tokens
FOR VALUES FROM ('r') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_s PARTITION OF fieldsets.tokens
FOR VALUES FROM ('s') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_t PARTITION OF fieldsets.tokens
FOR VALUES FROM ('t') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_u PARTITION OF fieldsets.tokens
FOR VALUES FROM ('u') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_v PARTITION OF fieldsets.tokens
FOR VALUES FROM ('v') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_w PARTITION OF fieldsets.tokens
FOR VALUES FROM ('w') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_x PARTITION OF fieldsets.tokens
FOR VALUES FROM ('x') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_y PARTITION OF fieldsets.tokens
FOR VALUES FROM ('y') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_z PARTITION OF fieldsets.tokens
FOR VALUES FROM ('z') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_0 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('0') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_1 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('1') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_2 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('2') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_3 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('3') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_4 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('4') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_5 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('5') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_6 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('6') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_7 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('7') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_8 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('8') TO (MAXVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_9 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('9') TO (MAXVALUE)
TABLESPACE fieldsets;
*/

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_default PARTITION OF fieldsets.tokens DEFAULT
TABLESPACE fieldsets;
