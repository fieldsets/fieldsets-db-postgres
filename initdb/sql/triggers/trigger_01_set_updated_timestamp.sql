/**
 * trigger_01_set_updated_timestamp: triggered before update to set updated field to current time.
 *
 * @param TEXT: db_schema
 * @param TEXT: table_name
 * @depends FUNCTION: trigger_set_updated_timestamp
 **/
CREATE OR REPLACE PROCEDURE public.trigger_01_set_updated_timestamp(db_schema TEXT, table_name TEXT) AS $procedure$
	DECLARE
		create_trigger_sql TEXT;
		sanitized_table_name TEXT;
	BEGIN 
	SELECT $trigger$
		DROP TRIGGER IF EXISTS trigger_01_set_updated_timestamp_%s ON %s.%s;
		CREATE TRIGGER trigger_01_set_updated_timestamp_%s
		AFTER UPDATE ON %s.%s
		FOR EACH ROW
		EXECUTE FUNCTION public.trigger_set_updated_timestamp();

		COMMENT ON TRIGGER trigger_01_set_updated_timestamp_%s ON %s.%s IS '
		/**
		 * trigger_01_set_updated_timestamp_%s: set updated field to current time
		 * @depends FUNCTION: trigger_set_updated_timestamp
		 * @priority 1
		 */';
	$trigger$ AS trigger_sql INTO create_trigger_sql;
	sanitized_table_name := trim(LEADING '__' FROM table_name);
	EXECUTE format(create_trigger_sql, sanitized_table_name, db_schema, table_name, sanitized_table_name, db_schema, table_name, sanitized_table_name, db_schema, table_name, sanitized_table_name);
	END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE public.trigger_01_set_updated_timestamp (TEXT, TEXT) IS 
'/**
 * trigger_01_set_updated_timestamp: triggered before update to set updated field to current time.
 *
 * @param TEXT: db_schema
 * @param TEXT: table_name
 * @depends FUNCTION: trigger_set_updated_timestamp
 **/';
