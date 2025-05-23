CREATE TABLE IF NOT EXISTS fieldsets.fields (
    id              BIGINT NOT NULL,
    token           VARCHAR(255) NOT NULL,
    label           TEXT NULL,
    type            FIELD_TYPE NOT NULL DEFAULT 'string'::FIELD_TYPE,
    parent          BIGINT NOT NULL DEFAULT 1,
    parent_token    VARCHAR(255) NOT NULL DEFAULT 'field',
    default_value   FIELD_VALUE NULL,
    store           STORE_TYPE NULL DEFAULT 'filter'::STORE_TYPE,
    meta_data       JSONB NULL DEFAULT '{}'::JSONB
) TABLESPACE fieldsets;
