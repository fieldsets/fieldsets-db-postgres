/**
 * Field Values Data Store
 * Should use tradional RDBMS table.
 */
CREATE TABLE IF NOT EXISTS fieldsets.values (
    id              BIGINT NOT NULL,
    field_id        BIGINT NOT NULL,
    type            FIELD_TYPE NOT NULL,
    value           FIELD_VALUE
)  PARTITION BY LIST (type)
TABLESPACE fieldsets;

-- Partition values by type, field_id, then by id % 5 modulus

-- fieldset
CREATE TABLE IF NOT EXISTS fieldsets.__fieldset_values PARTITION OF fieldsets.values
    FOR VALUES IN ('fieldset')
    TABLESPACE fieldsets;

-- string
CREATE TABLE IF NOT EXISTS fieldsets.__string_values PARTITION OF fieldsets.values
    FOR VALUES IN ('string')
    TABLESPACE fieldsets;

-- number
CREATE TABLE IF NOT EXISTS fieldsets.__number_values PARTITION OF fieldsets.values
    FOR VALUES IN ('number')
    TABLESPACE fieldsets;

-- decimal
CREATE TABLE IF NOT EXISTS fieldsets.__decimal_values PARTITION OF fieldsets.values
    FOR VALUES IN ('decimal')
    TABLESPACE fieldsets;

-- object
CREATE TABLE IF NOT EXISTS fieldsets.__object_values PARTITION OF fieldsets.values
    FOR VALUES IN ('object')
    TABLESPACE fieldsets;

-- list
CREATE TABLE IF NOT EXISTS fieldsets.__list_values PARTITION OF fieldsets.values
    FOR VALUES IN ('list')
    TABLESPACE fieldsets;

-- array
CREATE TABLE IF NOT EXISTS fieldsets.__array_values PARTITION OF fieldsets.values
    FOR VALUES IN ('array')
    TABLESPACE fieldsets;

-- vector
CREATE TABLE IF NOT EXISTS fieldsets.__vector_values PARTITION OF fieldsets.values
    FOR VALUES IN ('vector')
    TABLESPACE fieldsets;

-- bool
CREATE TABLE IF NOT EXISTS fieldsets.__bool_values PARTITION OF fieldsets.values
    FOR VALUES IN ('bool')
    TABLESPACE fieldsets;

-- date
CREATE TABLE IF NOT EXISTS fieldsets.__date_values PARTITION OF fieldsets.values
    FOR VALUES IN ('date')
    TABLESPACE fieldsets;

-- ts
CREATE TABLE IF NOT EXISTS fieldsets.__ts_values PARTITION OF fieldsets.values
    FOR VALUES IN ('ts')
    TABLESPACE fieldsets;

-- search
CREATE TABLE IF NOT EXISTS fieldsets.__search_values PARTITION OF fieldsets.values
    FOR VALUES IN ('search')
    TABLESPACE fieldsets;

-- uuid
CREATE TABLE IF NOT EXISTS fieldsets.__uuid_values PARTITION OF fieldsets.values
    FOR VALUES IN ('uuid')
    TABLESPACE fieldsets;

-- function
CREATE TABLE IF NOT EXISTS fieldsets.__function_values PARTITION OF fieldsets.values
    FOR VALUES IN ('function')
    TABLESPACE fieldsets;

-- custom
CREATE TABLE IF NOT EXISTS fieldsets.__custom_values PARTITION OF fieldsets.values
    FOR VALUES IN ('custom')
    TABLESPACE fieldsets;

-- Default to any if not defined.
CREATE TABLE IF NOT EXISTS fieldsets.__any_values PARTITION OF fieldsets.values DEFAULT TABLESPACE fieldsets;

