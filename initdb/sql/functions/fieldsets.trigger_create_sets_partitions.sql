/**
 * trigger_create_sets_partitions: triggered after a set is defined. Create a new data table partition.
 * @depends TRIGGER: create_set_partitions
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_create_sets_partitions() RETURNS trigger AS $function$
  DECLARE
    parent_table_name TEXT := TG_TABLE_NAME;
    partition_status RECORD;
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    cron_job_sql TEXT;
    partition_table_name TEXT;
  BEGIN

    IF starts_with(parent_table_name, '__') THEN
      partition_table_name := format('%s_%s', parent_table_name, NEW.parent_token);
    ELSE
      partition_table_name := format('__%s_%s', parent_table_name, NEW.parent_token);
    END IF;

    -- Test existance of table
    SELECT to_regclass(format('fieldsets.%I',partition_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      BEGIN
        create_tbl_sql := format('CREATE TABLE fieldsets.%I (LIKE fieldsets.%I INCLUDING ALL) TABLESPACE fieldsets;', partition_table_name, parent_table_name);
        --create_tbl_sql := format('CREATE TABLE IF NOT EXISTS fieldsets.%I PARTITION OF fieldsets.%I FOR VALUES IN (%L) TABLESPACE fieldsets;', partition_table_name, parent_table_name, NEW.parent_token);
        EXECUTE create_tbl_sql;

        EXECUTE format('INSERT INTO fieldsets.%I (id, token, label, parent, parent_token, meta) VALUES (%s, %L, %L, %s, %L, %L) ON CONFLICT DO NOTHING;', partition_table_name, NEW.id, NEW.token, NEW.label, NEW.parent, NEW.parent_token, NEW.meta);

        -- Asynchronously attach partition with scheduled cronjob.
        cron_job_token := format('attach_set_partition%s', partition_table_name);
        cron_job_sql := format('CALL fieldsets.attach_sets_partitions(%s, %L,%L);', NEW.parent, NEW.parent_token, parent_table_name);
        EXECUTE format('SELECT cron.schedule(%L, %L, %L);', cron_job_token, '* * * * *', cron_job_sql);
      EXCEPTION WHEN duplicate_table THEN
        NULL;
      END;
      RETURN NULL;
    ELSE
      RETURN NEW;
    END IF;

  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_sets_partitions() IS 
'/**
 * trigger_create_sets_partitions: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: create_sets_partitions
 **/';