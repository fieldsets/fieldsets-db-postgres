CREATE OR REPLACE FUNCTION fieldsets.trigger_create_fields_partitions()
RETURNS TRIGGER AS $function$
DECLARE
    sub_partitions_num INT4 := 5;
    tbl_sql TEXT;
    part_table_name TEXT;
    parent_fields_partition_name TEXT;
    fields_partition_name TEXT;
    parent_values_partition_name TEXT;
    values_partition_name TEXT;
BEGIN
    parent_fields_partition_name :=  format('fieldsets.__%s_fields', NEW.parent_token);
    tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF fieldsets.fields FOR VALUES IN (%s) PARTITION BY HASH(id);', parent_fields_partition_name, NEW.parent::TEXT);
    EXECUTE tbl_sql;

    fields_partition_name :=  format('fieldsets.__%s_%s_fields', NEW.token, NEW.parent_token);
    tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES IN (%s) PARTITION BY HASH(id);', fields_partition_name, parent_fields_partition_name, NEW.id::TEXT);
    EXECUTE tbl_sql;

    parent_values_partition_name :=  format('fieldsets.__%s_values', NEW.parent_token);
    tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF fieldsets.__%s_values FOR VALUES IN (%s) PARTITION BY HASH(id);', parent_values_partition_name, NEW.type, NEW.parent::TEXT);
    EXECUTE tbl_sql;

    values_partition_name :=  format('fieldsets.__%s_%s_values', NEW.token, NEW.parent_token);
    tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES IN (%s) PARTITION BY HASH(id);', values_partition_name, parent_values_partition_name, NEW.id::TEXT);
    EXECUTE tbl_sql;

    FOR remainder IN 0..(sub_partitions_num - 1)
    LOOP
        part_table_name :=  format('fieldsets.__%s_%s_fields_part_%s', NEW.token, NEW.parent_token, remainder);
        tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES WITH (MODULUS %s,REMAINDER %s)', part_table_name, fields_partition_name, sub_partitions_num, remainder);
        RAISE NOTICE 'Executing SQL: %', tbl_sql;
        EXECUTE tbl_sql;

        part_table_name :=  format('fieldsets.__%s_%s_values_part_%s', NEW.token, NEW.parent_token, remainder);
        tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES WITH (MODULUS %s,REMAINDER %s)', part_table_name, values_partition_name, sub_partitions_num, remainder);
        RAISE NOTICE 'Executing SQL: %', tbl_sql;
        EXECUTE tbl_sql;
    END LOOP;
    RETURN NEW;
END;
$function$
LANGUAGE plpgsql;