/**
 * create_id_partitions: takes a table name and generates a given number of subpartitions for id storage.
 * @param TEXT: parent_table_name
 * @param INT: sub_partitions_num (optional - default 5)
 * @param TEXT: schema_name (optional - default "fieldsets")
 * @param TEXT: tbl_name_prefix (optional - default "__")
 * @param TEXT: partition_by (optional - default "". options are "HASH($fieldname)", "LIST($fieldname)" and "RANGE($fieldname)")
 **/
CREATE OR REPLACE PROCEDURE fieldsets.create_id_partitions(parent_table_name TEXT, sub_partitions_num INT = 5, schema_name TEXT = 'fieldsets', tbl_name_prefix TEXT = '__', partition_by TEXT = '') AS $procedure$
DECLARE
    remainder INT;
    tbl_sql TEXT;
    partition_table_name TEXT;
BEGIN
    FOR remainder IN 0..(sub_partitions_num - 1)
    LOOP
        partition_table_name :=  format('%s.%s%s_part_%s', schema_name, tbl_name_prefix, parent_table_name, remainder::TEXT);
        tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I.%I FOR VALUES WITH (MODULUS %s,REMAINDER %s) TABLESPACE fieldsets;', partition_table_name, schema_name, parent_table_name, sub_partitions_num, remainder);
        EXECUTE tbl_sql;
    END LOOP;
END;
$procedure$
LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.create_id_partitions(TEXT,INT,TEXT,TEXT,TEXT) IS
'/**
 * create_id_partitions: takes a table name and generates a given number of subpartitions for id storage.
 * @param TEXT: parent_table_name
 * @param INT: sub_partitions_num (optional - default 5)
 * @param TEXT: schema_name (optional - default "fieldsets")
 * @param TEXT: tbl_name_prefix (optional - default "__")
 * @param TEXT: partition_by (optional - default "". options are "HASH($fieldname)", "LIST($fieldname)" and "RANGE($fieldname)")
 **/';
