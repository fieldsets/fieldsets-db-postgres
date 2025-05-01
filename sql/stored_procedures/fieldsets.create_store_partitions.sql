/**
 * create_store_partitions: takes a table name and generates a given number of subpartitions for all enumerated STORE_TYPEs.
 * @param TEXT: parent_partition (optional -default "fieldsets")
 * @param TEXT: parent_partition_token (optional -default "fieldset")
 * @param TEXT: table_space (optional -default "fieldsets")
 **/
CREATE OR REPLACE PROCEDURE fieldsets.create_store_partitions(parent_partition TEXT = 'fieldsets', parent_partition_token TEXT = 'fieldset', table_space TEXT = 'fieldsets') AS $procedure$
DECLARE
    tbl_sql TEXT;
   	store_type_list TEXT[];
    store_type_name TEXT;
    store_partition_table_name TEXT;
    parent_partition_store TEXT;
BEGIN
   	store_type_list := enum_range(NULL::STORE_TYPE);
    SELECT store INTO parent_partition_store FROM fieldsets.fieldsets WHERE token = parent_partition_token;
    IF parent_partition_store IS NULL THEN
        parent_partition_store := 'fieldset';
    END IF;
    FOREACH store_type_name IN ARRAY store_type_list
    LOOP
        IF starts_with(parent_partition, '__') THEN
            store_partition_table_name := format('fieldsets.%s_%s', parent_partition, store_type_name);
        ELSE
            store_partition_table_name := format('fieldsets.__%s_%s', parent_partition, store_type_name);
        END IF;

        tbl_sql := format('CREATE TABLE IF NOT EXISTS %s PARTITION OF fieldsets.%s FOR VALUES IN (%L) TABLESPACE %s;', store_partition_table_name, parent_partition, store_type_name, table_space);
        EXECUTE tbl_sql;
        tbl_sql := format('ALTER TABLE %s ADD CONSTRAINT %s_%s_unique UNIQUE (id);', store_partition_table_name, parent_partition, store_type_name);
        EXECUTE tbl_sql;
        tbl_sql := format('ALTER TABLE %s ADD CONSTRAINT %s_%s_token_unique UNIQUE (token);', store_partition_table_name, parent_partition, store_type_name);
        EXECUTE tbl_sql;
    END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.create_store_partitions(TEXT,TEXT,TEXT) IS
'/**
 * create_store_partitions: takes a table name and generates a given number of subpartitions for all enumerated STORE_TYPEs.
 * @param TEXT: parent_partition (optional -default "fieldsets")
 * @param TEXT: parent_token (optional -default "fieldset")
 * @param TEXT: table_space (optional -default "fieldsets")
 **/';
