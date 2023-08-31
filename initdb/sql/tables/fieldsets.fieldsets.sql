/**
 * Fieldsets can be thought of as subsets with their own unique ID.
 * They defined what data is what and which fields belong together.
 * A set can exist without being mapped to fields. This is useful for tagging individual fields alongside their fieldset grouping.
 */
CREATE TABLE IF NOT EXISTS fieldsets.fieldsets (
    id         	    BIGINT NOT NULL,
    set_id          BIGINT NOT NULL,
    field_id        BIGINT NOT NULL,
    value_id        BIGINT NOT NULL,
    store           STORE_TYPE NULL DEFAULT 'filter'::STORE_TYPE
) PARTITION BY LIST (store)
TABLESPACE fieldsets;

-- Partition by store, set_id, id, field_id, value_id % 5 (modulus)

-- Filter Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__filter_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('filter')
    TABLESPACE fieldsets;

-- Record Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__record_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('record')
    TABLESPACE fieldsets;

-- Sequence Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__sequence_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('sequence')
    TABLESPACE fieldsets;

-- Mapping Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__mapping_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('mapping')
    TABLESPACE fieldsets;

-- Document Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__document_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('document')
    TABLESPACE fieldsets;

-- Message/Log Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__message_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('message')
    TABLESPACE fieldsets;

-- ENUM Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__enum_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('enum')
    TABLESPACE fieldsets;

-- View Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__view_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('view')
    TABLESPACE fieldsets;

-- File Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__file_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('file')
    TABLESPACE fieldsets;

-- Program Partitions
CREATE TABLE IF NOT EXISTS fieldsets.__program_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('program')
    TABLESPACE fieldsets;

-- Custom Store Partition
CREATE TABLE IF NOT EXISTS fieldsets.__custom_fieldsets PARTITION OF fieldsets.fieldsets
    FOR VALUES IN ('custom')
    TABLESPACE fieldsets;

-- Default if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__default_fieldsets PARTITION OF fieldsets.fieldsets DEFAULT TABLESPACE fieldsets;
