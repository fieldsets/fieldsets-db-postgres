CREATE TABLE IF NOT EXISTS fieldsets.fields (
    id         			BIGINT NOT NULL,
    token     			VARCHAR(255) NOT NULL,
    label      			TEXT NULL,
    type				field_type NOT NULL,
    store               store_type NOT NULL,
    default_value 		field_value NULL,
    parent     			BIGINT NULL DEFAULT 0,
    meta  				JSONB NULL
) PARTITION BY LIST (store)
TABLESPACE fieldsets;

-- STORE TYPES
-- 'filter', 'record', 'mapping', 'document', 'message', 'sequence', 'file', 'program', 'custom'

-- FIELD TYPES
-- 'string', 'number', 'decimal', 'object', 'list', 'vector', 'bool', 'date', 'ts', 'function', 'fieldset', 'search', 'uuid', 'custom'

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

-- Mapping Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__mapping_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('mapping')
    TABLESPACE fieldsets;

-- Document Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__document_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('document')
    TABLESPACE fieldsets;

-- Message Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__message_fields PARTITION OF fieldsets.fields
    FOR VALUES IN ('message')
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

-- Default to custom data storage if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__default_fields PARTITION OF fieldsets.fields DEFAULT TABLESPACE fieldsets;
