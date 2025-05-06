/**
 * trigger_create_enum_data_type: triggered after insert into enum table. Create or update enumerated data type
 * @depends TRIGGER: trigger_32_create_enum_data_type
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_create_enum_data_type() RETURNS trigger AS $function$
  DECLARE
    sql_stmt TEXT := '';
    enum_exists BOOLEAN;
    enum_name TEXT;
  BEGIN
    enum_name = format('%s_enum', NEW.field_token);
    SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname=enum_name) INTO enum_exists;
    IF enum_exists THEN
      sql_stmt := format('ALTER TYPE fieldsets.%I ADD VALUE IF NOT EXISTS %L;', enum_name, NEW.token);
      EXECUTE sql_stmt;
    ELSE
      sql_stmt := format('CREATE TYPE fieldsets.%I AS ENUM (%L);', enum_name, NEW.token);
      EXECUTE sql_stmt;
    END IF;
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_enum_data_type() IS
'/**
 * trigger_create_enum_data_type: triggered after insert into enum table. Create or update enumerated data type
 * @depends TRIGGER: trigger_32_create_enum_data_type
 **/';