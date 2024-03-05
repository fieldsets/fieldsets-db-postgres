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

-- Partition by store, set_id, id, field_id, value_id % 5 (modulus)

-- Filter Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__filter_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('filter')
    TABLESPACE fieldsets;

-- Record Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__record_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('record')
    TABLESPACE fieldsets;

-- Sequence Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__sequence_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('sequence')
    TABLESPACE fieldsets;

-- Looki[] Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__lookup_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('lookup')
    TABLESPACE fieldsets;

-- Document Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__document_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('document')
    TABLESPACE fieldsets;

-- Message/Log Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__message_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('message')
    TABLESPACE fieldsets;

-- ENUM Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__enum_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('enum')
    TABLESPACE fieldsets;

-- View Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__view_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('view')
    TABLESPACE fieldsets;

-- File Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__file_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('file')
    TABLESPACE fieldsets;

-- Program Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__program_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('program')
    TABLESPACE fieldsets;

-- Custom Store Partition
CREATE TABLE IF NOT EXISTS fieldsets.__custom_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('custom')
    TABLESPACE fieldsets;

-- Default if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__default_fields PARTITION OF fieldsets.fields DEFAULT TABLESPACE fieldsets;

