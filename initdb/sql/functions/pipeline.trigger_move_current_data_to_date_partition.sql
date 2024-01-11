/**
 * trigger_move_current_data_to_date_partition: triggered before insert into default partition. When an insert happens on the default it is because the partition didn't exist at the time. Move it as it has been created.
 * @depends TRIGGER: create_new_date_partition
 **/
CREATE OR REPLACE FUNCTION pipeline.trigger_move_current_data_to_date_partition() RETURNS trigger AS $function$
  DECLARE
    db_schema TEXT := TG_ARGV[0];
    parent_table_name TEXT := TG_ARGV[1];
    create_tbl_sql TEXT;
    partition_month INT;
    partition_year INT;
    partition_table_name TEXT;
    range_start TEXT;
    range_stop TEXT;
  BEGIN 
    SELECT EXTRACT(MONTH FROM NEW.created) INTO partition_month;
    SELECT EXTRACT(YEAR FROM NEW.created) INTO partition_year;
    IF partition_month < 10 THEN
      range_start := format('%s-0%s-01', partition_year::TEXT, partition_month::TEXT);
    ELSE
      range_start := format('%s-%s-01', partition_year::TEXT, partition_month::TEXT);
    END IF;
    range_stop := DATE(DATE(range_start) + INTERVAL '1 MONTH')::TEXT;
    partition_table_name := format('__%s_%s_%s', parent_table_name, partition_year, partition_month);
    EXECUTE format('INSERT INTO %I.%I VALUES ($1.*)', db_schema, partition_table_name) USING NEW;

    RETURN NULL;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION pipeline.trigger_move_current_data_to_date_partition () IS 
'/**
 * trigger_move_current_data_to_date_partition: triggered before insert into default partition. When an insert happens on the default it is because the partition didn''t exist at the time. Move it as it has been created.
 * @depends TRIGGER: create_new_date_partition
 **/';