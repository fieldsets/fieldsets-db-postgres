/**
 * attach_sets_partitions: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param BIGINT: parent_id
 * @param TEXT: partition_token
 * @param TEXT: parent_table_name
 * @depends FUNCTION: trigger_create_sets_partition
 **/
CREATE OR REPLACE PROCEDURE fieldsets.attach_sets_partitions(partition_id BIGINT, partition_token TEXT, parent_table_name TEXT) AS $procedure$
  DECLARE
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    partition_table_name TEXT;
  BEGIN
    IF starts_with(parent_table_name, '__') THEN
      partition_table_name := format('%s_%s', parent_table_name, partition_token);
    ELSE
      partition_table_name := format('__%s_%s', parent_table_name, partition_token);
    END IF;

    EXECUTE format('ALTER TABLE fieldsets.%I ADD CONSTRAINT sets_%s_part_constraint CHECK (parent = %s);', partition_table_name, partition_token, partition_id);
    EXECUTE format('ALTER TABLE fieldsets.%I ATTACH PARTITION fieldsets.%I FOR VALUES IN (%s);', parent_table_name, partition_table_name, partition_id);

    cron_job_token := format('attach_set_partition%s', partition_table_name);
    EXECUTE format('SELECT cron.unschedule(%L);', cron_job_token);
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.attach_sets_partitions (BIGINT,TEXT,TEXT) IS
'/**
 * attach_sets_partitions: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param BIGINT: parent_id
 * @param TEXT: partition_token
 * @param TEXT: parent_table_name
 * @depends FUNCTION: trigger_create_sets_partition
 **/';