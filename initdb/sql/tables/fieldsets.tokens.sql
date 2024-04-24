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

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_a PARTITION OF fieldsets.tokens
FOR VALUES FROM ('a', MINVALUE) TO ('b', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_b PARTITION OF fieldsets.tokens
FOR VALUES FROM ('b', MINVALUE) TO ('c', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_c PARTITION OF fieldsets.tokens
FOR VALUES FROM ('c', MINVALUE) TO ('d', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_d PARTITION OF fieldsets.tokens
FOR VALUES FROM ('d', MINVALUE) TO ('e', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_e PARTITION OF fieldsets.tokens
FOR VALUES FROM ('e', MINVALUE) TO ('f', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_f PARTITION OF fieldsets.tokens
FOR VALUES FROM ('f', MINVALUE) TO ('g', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_g PARTITION OF fieldsets.tokens
FOR VALUES FROM ('g', MINVALUE) TO ('h', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_h PARTITION OF fieldsets.tokens
FOR VALUES FROM ('h', MINVALUE) TO ('i', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_i PARTITION OF fieldsets.tokens
FOR VALUES FROM ('i', MINVALUE) TO ('j', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_j PARTITION OF fieldsets.tokens
FOR VALUES FROM ('j', MINVALUE) TO ('k', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_k PARTITION OF fieldsets.tokens
FOR VALUES FROM ('k', MINVALUE) TO ('l', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_l PARTITION OF fieldsets.tokens
FOR VALUES FROM ('l', MINVALUE) TO ('m', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_m PARTITION OF fieldsets.tokens
FOR VALUES FROM ('m', MINVALUE) TO ('n', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_n PARTITION OF fieldsets.tokens
FOR VALUES FROM ('n', MINVALUE) TO ('o', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_o PARTITION OF fieldsets.tokens
FOR VALUES FROM ('o', MINVALUE) TO ('p', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_p PARTITION OF fieldsets.tokens
FOR VALUES FROM ('p', MINVALUE) TO ('q', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_q PARTITION OF fieldsets.tokens
FOR VALUES FROM ('q', MINVALUE) TO ('r', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_r PARTITION OF fieldsets.tokens
FOR VALUES FROM ('r', MINVALUE) TO ('s', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_s PARTITION OF fieldsets.tokens
FOR VALUES FROM ('s', MINVALUE) TO ('t', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_t PARTITION OF fieldsets.tokens
FOR VALUES FROM ('t', MINVALUE) TO ('u', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_u PARTITION OF fieldsets.tokens
FOR VALUES FROM ('u', MINVALUE) TO ('v', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_v PARTITION OF fieldsets.tokens
FOR VALUES FROM ('v', MINVALUE) TO ('w', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_w PARTITION OF fieldsets.tokens
FOR VALUES FROM ('w', MINVALUE) TO ('x', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_x PARTITION OF fieldsets.tokens
FOR VALUES FROM ('x', MINVALUE) TO ('y', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_y PARTITION OF fieldsets.tokens
FOR VALUES FROM ('y', MINVALUE) TO ('z', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_z PARTITION OF fieldsets.tokens
FOR VALUES FROM ('z', MINVALUE) TO ('0', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_0 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('0', MINVALUE) TO ('1', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_1 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('1', MINVALUE) TO ('2', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_2 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('2', MINVALUE) TO ('3', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_3 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('3', MINVALUE) TO ('4', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_4 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('4', MINVALUE) TO ('5', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_5 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('5', MINVALUE) TO ('6', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_6 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('6', MINVALUE) TO ('7', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_7 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('7', MINVALUE) TO ('8', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_8 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('8', MINVALUE) TO ('9', MINVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_9 PARTITION OF fieldsets.tokens
FOR VALUES FROM ('9', MINVALUE) TO ('9', MAZVALUE)
TABLESPACE fieldsets;

CREATE TABLE IF NOT EXISTS fieldsets.__tokens_default PARTITION OF fieldsets.tokens DEFAULT
TABLESPACE fieldsets;
