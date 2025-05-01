/**
 * attach_fieldsets_partitions: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param BIGINT: set_partition_id
 * @param TEXT: set_partition_token
 * @param TEXT: set_partition_table_name
 * @param BIGINT: parent_partition_id
 * @param TEXT: parent_partition_token
 * @param TEXT: parent_partition_table_name
 * @param TEXT: parent_table_name
 * @depends FUNCTION: trigger_create_fieldsets_partition
 **/
CREATE OR REPLACE PROCEDURE fieldsets.attach_fieldsets_partitions(set_partition_id BIGINT, set_partition_token TEXT, set_partition_table_name TEXT, parent_partition_id BIGINT, parent_partition_token TEXT, parent_partition_table_name TEXT, parent_table_name TEXT) AS $procedure$
  DECLARE
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    parent_part_token TEXT;
  BEGIN
    EXECUTE format('ALTER TABLE fieldsets.%I ADD CONSTRAINT fieldsets_set_%s_part_constraint CHECK (set_id = %s);', set_partition_table_name, set_partition_token, set_partition_id);
    EXECUTE format('ALTER TABLE fieldsets.%I ATTACH PARTITION fieldsets.%I FOR VALUES IN (%s);', parent_table_name, set_partition_table_name, set_partition_id);

    IF set_partition_token = parent_partition_token THEN
      parent_part_token := 'default';
    ELSE
      parent_part_token := parent_partition_token;
    END IF;

    EXECUTE format('ALTER TABLE fieldsets.%I ADD CONSTRAINT fieldsets_set_%s_%s_part_constraint CHECK (parent = %s);', parent_partition_table_name, set_partition_token, parent_part_token, parent_partition_id);
    EXECUTE format('ALTER TABLE fieldsets.%I ATTACH PARTITION fieldsets.%I FOR VALUES IN (%s);', set_partition_table_name, parent_partition_table_name, parent_partition_id);

    CALL fieldsets.create_fields_partitions(parent_partition_table_name, 'fieldsets', 3);

    cron_job_token := format('attach_fieldset_partition%s', set_partition_table_name);
    EXECUTE format('SELECT cron.unschedule(%L);', cron_job_token);
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.attach_fieldsets_partitions(BIGINT,TEXT,TEXT,BIGINT,TEXT,TEXT,TEXT) IS
'/**
 * attach_fieldsets_partitions: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param BIGINT: set_partition_id
 * @param TEXT: set_partition_token
 * @param TEXT: set_partition_table_name
 * @param BIGINT: parent_partition_id
 * @param TEXT: parent_partition_token
 * @param TEXT: parent_partition_table_name
 * @param TEXT: parent_table_name
 * @depends FUNCTION: trigger_create_fieldsets_partition
 **/';