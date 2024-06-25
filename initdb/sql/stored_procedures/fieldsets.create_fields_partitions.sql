/**
 * create_fields_partitions: takes a table name and generates a given number of subpartitions for all enumerated FIELD_TYPEs and optionally by id.
 * @param TEXT: parent_table_name (optional -default "fields")
 * @param TEXT: table_space_name (optional - default "fieldsets")
 * @param INT: sub_partitions_num (optional - default 0 - No id based partitions will be created unless this number is > 1)
 **/
CREATE OR REPLACE PROCEDURE fieldsets.create_fields_partitions(parent_table_name TEXT = 'fields', table_space_name TEXT = 'fieldsets', sub_partitions_num INT = 0) AS $procedure$
DECLARE
    remainder INT;
    tbl_sql TEXT;
    field_type_list TEXT[];
    field_type_name TEXT;
    type_partition_table_name TEXT;
    id_partition_table_name TEXT;
BEGIN
    field_type_list := enum_range(NULL::FIELD_TYPE);
    FOREACH field_type_name IN ARRAY field_type_list
    LOOP
        IF starts_with(parent_table_name, '__') THEN
            type_partition_table_name :=  format('fieldsets.%s_%s', parent_table_name, field_type_name);
        ELSE
            type_partition_table_name :=  format('fieldsets.__%s_%s', parent_table_name, field_type_name);
        END IF;

        IF sub_partitions_num > 1 THEN
            tbl_sql := format('CREATE TABLE IF NOT EXISTS %s PARTITION OF %s FOR VALUES IN (%L) PARTITION BY HASH(id) TABLESPACE %s;', type_partition_table_name, parent_table_name, field_type_name, table_space_name);
            EXECUTE tbl_sql;

            FOR remainder IN 0..(sub_partitions_num - 1)
            LOOP
                IF starts_with(parent_table_name, '__') THEN
                    id_partition_table_name :=  format('fieldsets.%s_%s_part_%s', parent_table_name, field_type_name, remainder::TEXT);
                ELSE
                    id_partition_table_name :=  format('fieldsets.__%s_%s_part_%s', parent_table_name, field_type_name, remainder::TEXT);
                END IF;

                tbl_sql := format('CREATE TABLE IF NOT EXISTS %s PARTITION OF %s FOR VALUES WITH (MODULUS %s,REMAINDER %s) TABLESPACE %s;', id_partition_table_name, type_partition_table_name, sub_partitions_num::TEXT, remainder::TEXT, table_space_name);
                EXECUTE tbl_sql;
            END LOOP;
        ELSE
            tbl_sql := format('CREATE TABLE IF NOT EXISTS %s PARTITION OF %s FOR VALUES IN (%L) TABLESPACE %s;', type_partition_table_name, parent_table_name, field_type_name, table_space_name);
            EXECUTE tbl_sql;
        END IF;
    END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.create_fields_partitions(TEXT,TEXT,INT) IS
'/**
 * create_fields_partitions: takes a table name and generates a given number of subpartitions for all enumerated FIELD_TYPEs and optionally by id.
 * @param TEXT: parent_table_name (optional -default "fields")
 * @param TEXT: table_space_name (optional - default "fieldsets")
 * @param INT: sub_partitions_num (optional - default 0 - No id based partitions will be created unless this number is > 1)
 **/';
