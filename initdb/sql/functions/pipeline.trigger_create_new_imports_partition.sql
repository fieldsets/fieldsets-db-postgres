/**
 * trigger_create_new_imports_partition: triggered before insert into data_values. Create a new data table if doesn't exist and notify parent table to attach as partition.
 * @depends TRIGGER: trigger_04_create_new_imports_partition
 **/
CREATE OR REPLACE FUNCTION pipeline.trigger_create_new_imports_partition() RETURNS trigger AS $function$
  DECLARE
    parent_table_name TEXT;
    partition_table_name TEXT;
    date_partition_table_name TEXT;
    create_tbl_sql TEXT;
    partition_status RECORD;
    partition_month INT;
    partition_year INT;
    range_start TEXT;
    range_stop TEXT;
  BEGIN
    partition_table_name := format('__imports_complete_%s', NEW.token::TEXT);
    parent_table_name := '__imports_complete';
    -- Test Parent existance
    SELECT to_regclass(format('pipeline.%I',partition_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      create_tbl_sql := format('CREATE TABLE IF NOT EXISTS pipeline.%I PARTITION OF pipeline.%I FOR VALUES IN (%L) PARTITION BY RANGE(created) TABLESPACE pipeline;', partition_table_name, parent_table_name, NEW.token::TEXT);
      EXECUTE create_tbl_sql;
    END IF;

    SELECT EXTRACT(MONTH FROM NEW.created) INTO partition_month;
    SELECT EXTRACT(YEAR FROM NEW.created) INTO partition_year;
    IF partition_month < 10 THEN
      range_start := format('%s-0%s-01', partition_year::TEXT, partition_month::TEXT);
    ELSE
      range_start := format('%s-%s-01', partition_year::TEXT, partition_month::TEXT);
    END IF;
    range_stop := DATE(DATE(range_start) + INTERVAL '1 MONTH')::TEXT;
    date_partition_table_name := format('%s_%s_%s', partition_table_name, partition_year, partition_month);
    create_tbl_sql := format('CREATE TABLE IF NOT EXISTS pipeline.%I PARTITION OF pipeline.%I FOR VALUES FROM (%L) TO (%L) TABLESPACE pipeline;', date_partition_table_name, partition_table_name, range_start::TEXT, range_stop::TEXT);
    EXECUTE create_tbl_sql;

    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION pipeline.trigger_create_new_imports_partition () IS
'/**
 * trigger_create_new_imports_partition: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: trigger_create_new_imports_partition
 **/';