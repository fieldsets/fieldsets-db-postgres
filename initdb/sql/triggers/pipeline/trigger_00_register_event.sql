/**
 * trigger_00_register_event: triggered before insert into `pipeline.events`. Validate events table with expanded data structure from JSON.
 *
 * Newly created partitions do not inherit triggers and they must be added via their own DDL. This is wrapped in a procedure so it can be called via our asynchronous function.
 *
 * @param TEXT: partition_table_name
 * @depends FUNCTION: trigger_create_new_date_partition
 **/
CREATE OR REPLACE PROCEDURE pipeline.trigger_00_register_event(partition_table_name TEXT) AS $procedure$
	DECLARE
		create_trigger_sql TEXT;
		sanitized_table_name TEXT;
	BEGIN 
		SELECT $trigger$
			DROP TRIGGER IF EXISTS trigger_00_register_%s ON pipeline.%s;
			CREATE TRIGGER trigger_00_register_%s
			BEFORE INSERT ON pipeline.%s
			FOR EACH ROW 
			EXECUTE FUNCTION pipeline.trigger_register_event();

			COMMENT ON TRIGGER trigger_00_register_%s ON pipeline.%s IS '
			/**
			 * trigger_00_register_%s: triggered before insert into `pipeline.events` and its partitions. Validate events table with expanded data structure from JSON.
			 * @depends FUNCTION: trigger_register_event
			 * @priority 00
			 **/';
		$trigger$ AS trigger_sql INTO create_trigger_sql;
		sanitized_table_name := trim(LEADING '__' FROM partition_table_name);
		EXECUTE format(create_trigger_sql, sanitized_table_name, partition_table_name, sanitized_table_name, partition_table_name, sanitized_table_name, partition_table_name, sanitized_table_name);
	END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE pipeline.trigger_00_register_event (TEXT) IS 
'/**
 * trigger_00_register_event: triggered before insert into `pipeline.events`. Validate events table with expanded data structure from JSON.
 *
 * Newly created partitions do not inherit triggers and they must be added via their own DDL. This is wrapped in a procedure so it can be called via our asynchronous function.
 *
 * @param TEXT: partition_table_name
 * @depends FUNCTION: trigger_create_new_date_partition
 **/';
