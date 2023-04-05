/**
 * trigger_create_new_date_partition: triggered before insert into data_values. Create a new data table if doesn't exist and notify parent table to attach as partition.
 * @depends TRIGGER: trigger_05_create_new_date_partition
 **/
CREATE OR REPLACE FUNCTION public.trigger_create_new_date_partition() RETURNS trigger AS $function$
  DECLARE
    db_schema TEXT := TG_ARGV[0];
    parent_table_name TEXT := TG_ARGV[1];
    partition_tablespace TEXT := TG_ARGV[2];
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    cron_job_sql TEXT;
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
    BEGIN
  	  create_tbl_sql := format('CREATE TABLE %I.%I (LIKE %I.%I INCLUDING ALL) TABLESPACE %I;', db_schema, partition_table_name, db_schema, parent_table_name, partition_tablespace);
      EXECUTE create_tbl_sql;
      
      -- Asynchronously attach partition with scheduled cronjob.
      cron_job_token := format('attach_partition%s', partition_table_name);
      cron_job_sql := format('CALL public.attach_date_partition(%L,%L,%L,%L,%L);', db_schema, parent_table_name, partition_table_name, partition_year, partition_month);
      EXECUTE format('SELECT cron.schedule(%L, %L, %L);', cron_job_token, '* * * * *', cron_job_sql);
    EXCEPTION WHEN duplicate_table THEN
      NULL;
    END;
    
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.trigger_create_new_date_partition () IS 
'/**
 * trigger_create_new_date_partition: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: create_new_date_partition
 **/';