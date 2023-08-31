CREATE OR REPLACE FUNCTION fieldsets.trigger_create_sets_partitions()
RETURNS TRIGGER AS $function$
DECLARE
    sub_partitions_num INT4 := 5;
    tbl_sql TEXT;
    part_table_name TEXT;
    parent_table_name TEXT;
    parent_token TEXT;
    parent_id BIGINT;
BEGIN
    parent_table_name :=  format('__%s_sets', parent_token);
    tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF fieldsets.sets FOR VALUES IN (%s) PARTITION BY HASH(id);', parent_table_name, NEW.parent::TEXT);
    --EXECUTE tbl_sql;

    FOR remainder IN 0..(sub_partitions_num - 1)
    LOOP
        part_table_name :=  format('__%s_sets_part_%s', NEW.parent_token, remainder);
        tbl_sql := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF fieldsets.%I FOR VALUES WITH (MODULUS %s,REMAINDER %s)', part_table_name, parent_table_name, sub_partitions_num, remainder);
        RAISE NOTICE 'Executing SQL: %', tbl_sql;
        --EXECUTE tbl_sql;
    END LOOP;
    RETURN NEW;
END;
$function$
LANGUAGE plpgsql;