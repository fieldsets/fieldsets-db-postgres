/**
 * trigger_10_forwarddefault_partition_data: Triggered when writing to the default `default` partition. Meaning no table partition exists yet. Forward to newly created partition.
 *
 * @param TEXT: db_schema
 * @param TEXT: table_name. Parent of default partition named __${table_name}_default
 * @depends FUNCTION: trigger_move_default_data_to_date_partition
 **/
CREATE OR REPLACE PROCEDURE public.trigger_10_forward_default_partition_data(db_schema TEXT, table_name TEXT) AS $procedure$
  DECLARE
    create_trigger_sql TEXT;
  BEGIN 
    SELECT $trigger$
		DROP TRIGGER IF EXISTS trigger_10_forward_default_partition_data_%s ON %s.__%s_default;
		CREATE TRIGGER trigger_10_forward_default_partition_data_%s
		BEFORE INSERT ON %s.__%s_default
		FOR EACH ROW 
		EXECUTE FUNCTION public.trigger_move_default_data_to_date_partition(%L, %L);

		COMMENT ON TRIGGER trigger_10_forward_default_partition_data_%s ON %s.__%s_default IS '
		/**
		 * trigger_10_forward_default_partition_data_%s: triggered when writing to the default `default` partition. Meaning no table partition exists yet. Forward to newly created partition.
		 * @depends FUNCTION: trigger_move_default_data_to_date_partition
		 * @priority 10
		 **/';
    $trigger$ AS trigger_sql INTO create_trigger_sql;
    EXECUTE format(create_trigger_sql, table_name, db_schema, table_name, table_name, db_schema, table_name, db_schema, table_name, table_name, db_schema, table_name, table_name);
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE public.trigger_10_forward_default_partition_data (TEXT, TEXT) IS 
'/**
 * trigger_10_forward_default_partition_data: Triggered when writing to the default `default` partition. Meaning no table partition exists yet. Forward to newly created partition.
 *
 * @param TEXT: db_schema
 * @param TEXT: table_name. Parent of default partition named __${table_name}_default
 * @depends FUNCTION: trigger_move_default_data_to_date_partition
 **/';
