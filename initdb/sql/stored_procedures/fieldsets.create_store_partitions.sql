/**
 * create_store_partitions: takes a table name and generates a given number of subpartitions for all enumerated STORE_TYPEs.
 * @param TEXT: parent_table_name (optional -default "fieldsets")
 * @param TEXT: schema_name (optional - default "fieldsets")
 **/
CREATE OR REPLACE PROCEDURE fieldsets.create_store_partitions(parent_table_name TEXT = 'fieldsets', schema_name TEXT = 'fieldsets') AS $procedure$
DECLARE
    tbl_sql TEXT;
   	store_type_list TEXT[];
    store_type_name TEXT;
    store_partition_table_name TEXT;
BEGIN
   	store_type_list := enum_range(NULL::STORE_TYPE);
    FOREACH store_type_name IN ARRAY store_type_list
    LOOP
        IF starts_with(parent_table_name, '__') THEN
            store_partition_table_name := format('%s.%s_%s', schema_name, parent_table_name, store_type_name);
        ELSE
            store_partition_table_name := format('%s.__%s_%s', schema_name, parent_table_name, store_type_name);
        END IF;

        tbl_sql := format('CREATE TABLE IF NOT EXISTS %s PARTITION OF %I.%I FOR VALUES IN (%L) TABLESPACE fieldsets;', store_partition_table_name, schema_name, parent_table_name, store_type_name);
        EXECUTE tbl_sql;
    END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.create_store_partitions(TEXT,TEXT) IS
'/**
 * create_store_partitions: takes a table name and generates a given number of subpartitions for all enumerated STORE_TYPEs.
 * @param TEXT: parent_table_name (optional -default "fieldsets")
 * @param TEXT: schema_name (optional - default "fieldsets")
 **/';
