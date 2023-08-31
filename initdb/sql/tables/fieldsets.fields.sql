CREATE TABLE IF NOT EXISTS fieldsets.fields (
    id         			BIGINT NOT NULL,
    token     			VARCHAR(255) NOT NULL,
    label      			TEXT NULL,
    type				FIELD_TYPE NOT NULL DEFAULT 'string'::FIELD_TYPE,
    parent     			BIGINT NULL,
    parent_token        VARCHAR(255) NULL,
    default_value 		FIELD_VALUE NULL,
    meta  				JSONB NULL
) PARTITION BY LIST (parent)
TABLESPACE fieldsets;

-- partition by parent, id % 5 (modulus)

-- Default if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__default_fields PARTITION OF fieldsets.fields DEFAULT TABLESPACE fieldsets;
