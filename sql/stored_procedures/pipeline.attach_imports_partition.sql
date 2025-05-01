/**
 * attach_imports_partition: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param TEXT: db_schema
 * @param TEXT: parent_table_name
 * @param TEXT: partition_table_name
 * @param NUMERIC: partition_year
 * @param NUMERIC: partition_month
 * @depends FUNCTION: trigger_create_new_imports_partition
 **/
CREATE OR REPLACE PROCEDURE pipeline.attach_imports_partition(db_schema TEXT, parent_table_name TEXT, partition_table_name TEXT, partition_year NUMERIC, partition_month NUMERIC) AS $procedure$
  DECLARE
    create_tbl_sql TEXT;
    cron_job_token TEXT;
    range_start TEXT;
    range_stop TEXT;
  BEGIN 
    IF partition_month < 10 THEN
      range_start := format('%s-0%s-01', partition_year::TEXT, partition_month::TEXT);
    ELSE
      range_start := format('%s-%s-01', partition_year::TEXT, partition_month::TEXT);
    END IF;

    range_stop := DATE(DATE(range_start) + INTERVAL '1 MONTH')::TEXT;
    partition_table_name := format('__%s_%s_%s', parent_table_name, partition_year, partition_month);
    EXECUTE format('ALTER TABLE %I.%I ADD CONSTRAINT %s_%s_%s CHECK (created >= DATE(%L) AND created < DATE(%L));', db_schema, partition_table_name, parent_table_name, partition_year::TEXT, partition_month::TEXT, range_start, range_stop);
    EXECUTE format('ALTER TABLE %I.%I ATTACH PARTITION %I.%I FOR VALUES FROM (%L) TO (%L);', db_schema, parent_table_name, db_schema, partition_table_name, range_start, range_stop);

    cron_job_token := format('attach_partition%s', partition_table_name);
    EXECUTE format('SELECT cron.unschedule(%L);', cron_job_token);
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE pipeline.attach_imports_partition (TEXT,TEXT,TEXT,NUMERIC,NUMERIC) IS 
'/**
 * attach_imports_partition: Run as a one time cron job. Attach a partition and unschedule the job.
 * @param TEXT: db_schema
 * @param TEXT: parent_table_name
 * @param TEXT: partition_table_name
 * @param NUMERIC: partition_year
 * @param NUMERIC: partition_month
 * @depends FUNCTION: trigger_create_new_imports_partition
 **/';