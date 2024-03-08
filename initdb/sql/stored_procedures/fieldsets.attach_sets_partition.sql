/**
 * attach_sets_partition: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param TEXT: partition_token
 * @param TEXT: parent_table_name
 * @depends FUNCTION: trigger_create_sets_partition
 **/
CREATE OR REPLACE PROCEDURE fieldsets.attach_sets_partition(partition_token TEXT, parent_table_name TEXT) AS $procedure$
  DECLARE
    create_tbl_sql TEXT;
    cron_job_token TEXT;
  BEGIN 
    partition_table_name := format('__%s_%s', parent_table_name, partition_token);
    EXECUTE format('ALTER TABLE fieldsets.%I ADD CONSTRAINT %s_%s_part_constraint CHECK (parent_token = %L);', partition_table_name, parent_table_name, partition_token, partition_token);
    EXECUTE format('ALTER TABLE fieldsets.%I ATTACH PARTITION fieldsets.%I FOR VALUES IN (%L);', parent_table_name, partition_table_name, partition_token);

    cron_job_token := format('attach_partition%s', partition_table_name);
    EXECUTE format('SELECT cron.unschedule(%L);', cron_job_token);
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.attach_sets_partition (TEXT,TEXT) IS 
'/**
 * attach_sets_partition: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param TEXT: partition_token
 * @param TEXT: parent_table_name
 * @depends FUNCTION: trigger_create_sets_partition
 **/';