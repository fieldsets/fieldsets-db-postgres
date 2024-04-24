/**
 * trigger_04_create_new_imports_partition: triggered before insert into pipeline.imports table. Create a new partition for the token and create date partitions using the month of the current year if it does not exist using the `created` field.
 *
 * @param TEXT: db_schema
 * @param TEXT: table_name
 * @param TEXT: partition_tablespace
 * @depends FUNCTION: pipeline.trigger_create_new_imports_partition
 **/
CREATE OR REPLACE PROCEDURE pipeline.trigger_04_create_new_imports_partition(db_schema TEXT, table_name TEXT, partition_tablespace TEXT) AS $procedure$
  DECLARE
    create_trigger_sql TEXT;
    sanitized_table_name TEXT;
  BEGIN 
    SELECT $trigger$
			DROP TRIGGER IF EXISTS trigger_04_create_new_imports_partition_%s ON %s.%s;
			CREATE TRIGGER trigger_04_create_new_imports_partition_%s
			BEFORE INSERT ON %s.%s
			FOR EACH ROW
			EXECUTE FUNCTION pipeline.trigger_create_new_imports_partition(%L, %L, %L);

			COMMENT ON TRIGGER trigger_04_create_new_imports_partition_%s ON %s.%s IS '
			/**
			 * trigger_04_create_new_imports_partition_%s: triggered before insert into pipeline.imports table. Create a new partition for the token and create date partitions using the month of the current year if it does not exist using the `created` field.
			 * @depends FUNCTION: pipeline.trigger_create_new_imports_partition
			 * @priority 4
			 **/';
    $trigger$ AS trigger_sql INTO create_trigger_sql;
    sanitized_table_name := trim(LEADING '__' FROM table_name);
    EXECUTE format(create_trigger_sql, sanitized_table_name, db_schema, table_name, sanitized_table_name, db_schema, table_name, db_schema, table_name, partition_tablespace, sanitized_table_name, db_schema, table_name, sanitized_table_name);
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE public.trigger_05_create_new_date_partition (TEXT, TEXT, TEXT) IS 
'/**
 * trigger_05_create_new_date_partition: triggered before insert into given table. Create a new partition for the month of the current year if it does not exist using the `created` field.
 *
 * @param TEXT: db_schema
 * @param TEXT: table_name
 * @param TEXT: partition_tablespace
 * @depends FUNCTION: trigger_create_new_date_partition
 **/';
