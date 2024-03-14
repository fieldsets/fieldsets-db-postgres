/**
 * trigger_create_fieldsets_partitions: triggered before a set is defined. Create a new data table partition.
 * @depends TRIGGER: create_fieldset_partitions
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_create_fieldsets_partitions() RETURNS trigger AS $function$
  DECLARE
    parent_table_name TEXT := '';
    partition_status RECORD;
    create_tbl_sql TEXT;
    partition_table_name TEXT;
  BEGIN

    partition_table_name := format('__fieldsets_%s', NEW.token);
    parent_table_name := format('__fieldsets_%s', NEW.parent_token);

    -- Test Parent existance
    SELECT to_regclass(format('fieldsets.%I',parent_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      create_tbl_sql := format('CREATE TABLE IF NOT EXISTS fieldsets.%I PARTITION OF fieldsets.fieldsets FOR VALUES IN (%s) PARTITION BY LIST(store) TABLESPACE fieldsets;', parent_table_name, NEW.parent::TEXT);
      EXECUTE create_tbl_sql;
      create_tbl_sql := format('CALL fieldsets.create_store_partitions(%L, %L);', parent_table_name, 'fieldsets');
      EXECUTE create_tbl_sql;
    END IF;

    -- Test Set existance
    SELECT to_regclass(format('fieldsets.%I',partition_table_name)) INTO partition_status;
    IF partition_status IS NULL THEN
      create_tbl_sql := format('CREATE TABLE IF NOT EXISTS fieldsets.%I PARTITION OF fieldsets.fieldsets FOR VALUES IN (%s) PARTITION BY LIST(store) TABLESPACE fieldsets;', partition_table_name, NEW.id::TEXT);
      EXECUTE create_tbl_sql;
      create_tbl_sql := format('CALL fieldsets.create_store_partitions(%L, %L);', partition_table_name, 'fieldsets');
      EXECUTE create_tbl_sql;
    END IF;
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_fieldsets_partitions() IS
'/**
 * trigger_create_fieldsets_partitions: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: create_fieldsets_partitions
 **/';