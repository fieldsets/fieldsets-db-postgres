/**
 * trigger_create_field_enum_store: triggered before insert. Set parent id equal to meta data parent_token
 * @depends TRIGGER: trigger_01_create_field_enum_store
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_create_field_enum_store()
RETURNS TRIGGER AS $function$
  DECLARE
    type_exists BOOLEAN;
    create_enum_sql TEXT;
    enum_value TEXT;
    field_values_sql TEXT;
    enum_list JSON;
    data_value_string TEXT;
    json_list JSON;
  BEGIN
    RAISE NOTICE 'NEW Data: %', NEW;
	  SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname=NEW.token) INTO type_exists;
    IF NOT type_exists THEN
      data_value_string := CAST(NEW.default_value AS TEXT);
      field_values_sql := format('SELECT (default_value).%s::JSON AS value FROM (SELECT %L::FIELD_VALUE AS default_value) fv', NEW.type, data_value_string);
      EXECUTE field_values_sql INTO enum_list;
      RAISE NOTICE 'Enum List: %', enum_list;
      create_enum_sql := format('CREATE TYPE %I AS ENUM (', NEW.token);
      FOR enum_value IN
        SELECT * FROM json_array_elements_text(enum_list)
      LOOP
        create_enum_sql := format('%s %L,', create_enum_sql, enum_value);
      END LOOP;
      create_enum_sql := TRIM(TRAILING ',' FROM create_enum_sql);
      create_enum_sql := format('%s );', create_enum_sql);
      RAISE NOTICE 'Enum SQL: %', create_enum_sql;
      EXECUTE create_enum_sql;
    END IF;
    NEW.default_value := NULL;
  RETURN NEW;
END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_field_enum_store () IS
'/**
 * trigger_create_field_enum_store: triggered before insert. Set parent id equal to meta data parent_token
 * @depends TRIGGER: trigger_01_create_field_enum_store
 **/';
