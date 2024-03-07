/**
 * create_store_type_partitions: takes a table name and generates a given number of subpartitions for all enumerated STORE_TYPEs.
 * @param TEXT: parent_table_name
 * @param TEXT: schema_name (optional - default "fieldsets")
 * @param TEXT: tbl_name_prefix (optional - default "__")
 * @param TEXT: partition_by (optional - default "". options are "HASH($fieldname)", "LIST($fieldname)" and "RANGE($fieldname)")
 **/
CREATE OR REPLACE PROCEDURE fieldsets.create_store_type_partitions(parent_table_name TEXT, schema_name TEXT = 'fieldsets', tbl_name_prefix TEXT = '__', partition_by TEXT = '') AS $procedure$
DECLARE
    tbl_sql TEXT;
   	store_type_list TEXT[];
    store_type_name TEXT;
    partition_table_name TEXT;
    partition_by_sql TEXT := '';
BEGIN
    IF length(partition_by) > 0 THEN
        partition_by_sql := format(' PARTITION BY %s', partition_by);
    END IF;

   	store_type_list := enum_range(NULL::STORE_TYPE);
    FOREACH store_type_name IN ARRAY store_type_list
    LOOP
        partition_table_name :=  format('%s.%s%s_%s', schema_name, tbl_name_prefix, parent_table_name, store_type_name);
        tbl_sql := format('CREATE TABLE IF NOT EXISTS %s PARTITION OF %I.%I FOR VALUES IN (%L)%s TABLESPACE fieldsets;', partition_table_name, schema_name, parent_table_name, store_type_name, partition_by_sql);
        EXECUTE tbl_sql;
    END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.create_store_type_partitions(TEXT,TEXT,TEXT,TEXT) IS
'/**
 * create_store_type_partitions: takes a table name and generates a given number of subpartitions for all enumerated STORE_TYPEs.
 * @param TEXT: parent_table_name
 * @param TEXT: schema_name (optional - default "fieldsets")
 * @param TEXT: tbl_name_prefix (optional - default "__")
 * @param TEXT: partition_by (optional - default "". options are "HASH($fieldname)", "LIST($fieldname)" and "RANGE($fieldname)")
 **/';
