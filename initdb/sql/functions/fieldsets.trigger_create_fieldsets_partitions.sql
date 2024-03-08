/**
 * trigger_create_fieldsets_partitions: triggered after a set is defined. Create a new data table partition.
 * @depends TRIGGER: create_fieldsets_partitions
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_create_fieldsets_partitions() RETURNS trigger AS $function$
  DECLARE
    parent_table_name TEXT := TG_TABLE_NAME;
    partition_status RECORD;
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    cron_job_sql TEXT;
    set_token TEXT;
    set_partition_table_name TEXT := NULL;
    parent_partition_table_name TEXT := NULL;
  BEGIN
    SELECT token INTO set_token FROM fieldsets.sets WHERE id = NEW.set_id;

    --Anything going into the default partition should just use 'fieldsets' as the table name
    IF parent_table_name = '__default_fieldsets' THEN
      parent_table_name := 'fieldsets';
    END IF;

    IF starts_with(parent_table_name, '__') THEN
      set_partition_table_name := format('%s_%s', parent_table_name, set_token);
      IF set_token <> NEW.parent_token THEN
        parent_partition_table_name := format('%s_%s_%s', parent_table_name, set_token, NEW.parent_token);
      ELSE
        parent_partition_table_name := format('%s_%s_default', parent_table_name, set_token);
      END IF;
    ELSE
      set_partition_table_name := format('__%s_%s', parent_table_name, set_token);
      IF set_token <> NEW.parent_token THEN
        parent_partition_table_name := format('__%s_%s_%s', parent_table_name, set_token, NEW.parent_token);
      ELSE
        parent_partition_table_name := format('__%s_%s_default', parent_table_name, set_token);
      END IF;
    END IF;

    -- Test existance of table & create set_id partition to attach
    SELECT to_regclass(format('fieldsets.%I',set_partition_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      BEGIN
        create_tbl_sql := format('CREATE TABLE fieldsets.%I (LIKE fieldsets.%I INCLUDING ALL) PARTITION BY LIST (parent) TABLESPACE fieldsets;', set_partition_table_name, parent_table_name);
        EXECUTE create_tbl_sql;
      EXCEPTION WHEN duplicate_table THEN
        NULL;
      END;
    END IF;

    -- Test existance of table & create parent id partition to attach
    partition_status := NULL;
    SELECT to_regclass(format('fieldsets.%I',parent_partition_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      BEGIN
        create_tbl_sql := format('CREATE TABLE fieldsets.%I (LIKE fieldsets.%I INCLUDING ALL) PARTITION BY LIST (store) TABLESPACE fieldsets;', parent_partition_table_name, parent_table_name);
        EXECUTE create_tbl_sql;
      EXCEPTION WHEN duplicate_table THEN
        NULL;
      END;
    END IF;

    -- Asynchronously attach partitions with scheduled cronjob and generate store and type partitions.
    cron_job_token := format('attach_fieldset_partition%s', set_partition_table_name);
    cron_job_sql := format('CALL fieldsets.attach_fieldsets_partitions(%s,%L,%L,%s,%L,%L,%L);', NEW.set_id, set_token, set_partition_table_name, NEW.parent, NEW.parent_token, parent_partition_table_name, parent_table_name);
    EXECUTE format('SELECT cron.schedule(%L, %L, %L);', cron_job_token, '* * * * *', cron_job_sql);

    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_fieldsets_partitions() IS
'/**
 * trigger_create_fieldsets_partitions: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: create_sets_partitions
 **/';