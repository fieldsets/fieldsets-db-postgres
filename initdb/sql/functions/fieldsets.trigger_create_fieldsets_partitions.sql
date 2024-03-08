/**
 * trigger_create_fieldsets_partitions: triggered after a set is defined. Create a new data table partition.
 * @depends TRIGGER: create_fieldsets_partitions
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_create_fieldsets_partitions() RETURNS trigger AS $function$
  DECLARE
    partition_status BOOLEAN;
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    cron_job_sql TEXT;
    partition_table_name TEXT;
    parent_table_name TEXT := TG_TABLE_NAME;
  BEGIN 
    partition_table_name := format('__%s_%s', parent_table_name, NEW.parent_token);
    -- Test existance of table
    SELECT to_regclass(format('fieldsets.%s',partition_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      BEGIN
        create_tbl_sql := format('CREATE TABLE fieldsets.%I (LIKE fieldsets.%I INCLUDING ALL) TABLESPACE fieldsets;', partition_table_name, parent_table_name);
        EXECUTE create_tbl_sql;
        
        -- Asynchronously attach partition with scheduled cronjob.
        cron_job_token := format('attach_set_partition%s', partition_table_name);
        cron_job_sql := format('CALL fieldsets.attach_sets_partition(%L,%L);', NEW.parent_token, parent_table_name);
        EXECUTE format('SELECT cron.schedule(%L, %L, %L);', cron_job_token, '* * * * *', cron_job_sql);
      EXCEPTION WHEN duplicate_table THEN
        NULL;
      END;
    END IF;
    
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_fieldsets_partitions() IS 
'/**
 * trigger_create_fieldsets_partitions: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: create_sets_partitions
 **/';