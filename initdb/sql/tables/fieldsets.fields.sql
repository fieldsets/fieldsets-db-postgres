CREATE TABLE IF NOT EXISTS fieldsets.fields (
    id         			BIGINT NOT NULL,
    token     			VARCHAR(255) NOT NULL,
    label      			TEXT NULL,
    type				FIELD_TYPE NOT NULL DEFAULT 'string'::FIELD_TYPE,
    parent     			BIGINT NULL,
    parent_token        VARCHAR(255) NULL,
    default_value 		FIELD_VALUE NULL,
    store               STORE_TYPE NULL DEFAULT 'filter'::STORE_TYPE,
    meta  				JSONB NULL
) PARTITION BY LIST (store)
TABLESPACE fieldsets;

-- Partition by store, type, id % 5 (modulus)

-- Default if not defined.
-- CREATE TABLE IF NOT EXISTS fieldsets.__default_fields PARTITION OF fieldsets.fields DEFAULT TABLESPACE fieldsets;

