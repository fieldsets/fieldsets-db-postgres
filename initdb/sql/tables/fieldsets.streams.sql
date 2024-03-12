/**
 * Streaming Data Store.
 */

CREATE UNLOGGED TABLE IF NOT EXISTS fieldsets.streams(
    id         	    BIGINT NOT NULL,
    parent     	    BIGINT NULL DEFAULT 0,
    data            TEXT NULL,
    created         TIMESTAMPTZ NOT NULL DEFAULT NOW()
) TABLESPACE streams;
