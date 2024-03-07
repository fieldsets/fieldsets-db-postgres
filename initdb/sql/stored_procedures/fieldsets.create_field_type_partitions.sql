/**
 * create_field_type_partitions: takes a table name and generates a given number of subpartitions for all enumerated FIELD_TYPEs.
 * @param TEXT: parent_table_name
 * @param TEXT: schema_name (optional - default "fieldsets")
 * @param TEXT: tbl_name_prefix (optional - default "__")
 * @param TEXT: partition_by (optional - default "". options are "HASH($fieldname)", "LIST($fieldname)" and "RANGE($fieldname)")
 **/
CREATE OR REPLACE PROCEDURE fieldsets.create_field_type_partitions(parent_table_name TEXT, schema_name TEXT = 'fieldsets', tbl_name_prefix TEXT = '__', partition_by TEXT = '') AS $procedure$
DECLARE
    tbl_sql TEXT;
    field_type_list TEXT[];
    field_type_name TEXT;
    partition_table_name TEXT;
    partition_by_sql TEXT := '';
BEGIN
    IF length(partition_by) > 0 THEN
        partition_by_sql := format(' PARTITION BY %s', partition_by);
    END IF;

    field_type_list := enum_range(NULL::FIELD_TYPE);
    FOREACH field_type_name IN ARRAY field_type_list
    LOOP
        partition_table_name :=  format('%s.%s%s_%s', schema_name, tbl_name_prefix, parent_table_name, field_type_name);
        tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I.%I FOR VALUES IN (%s)%s TABLESPACE fieldsets;', partition_table_name, schema_name, parent_table_name, field_type_name, partition_by_sql);
        EXECUTE tbl_sql;
    END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.create_field_type_partitions(TEXT,TEXT,TEXT,TEXT) IS
'/**
 * create_field_type_partitions: takes a table name and generates a given number of subpartitions for id storage.
 * @param TEXT: parent_table_name
 * @param TEXT: schema_name (optional - default "fieldsets")
 * @param TEXT: tbl_name_prefix (optional - default "__")
 * @param TEXT: partition_by (optional - default "". options are "HASH($fieldname)", "LIST($fieldname)" and "RANGE($fieldname)")
 **/';
