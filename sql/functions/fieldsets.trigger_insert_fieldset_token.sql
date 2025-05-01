/**
 * trigger_insert_fieldset_token: triggered before a fieldset is entered. Create a new fieldset token entry.
 * @depends TRIGGER: trigger_11_insert_fieldset_token
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_insert_fieldset_token() RETURNS trigger AS $function$
  DECLARE
    fieldset_id BIGINT;
  BEGIN

    IF NEW.id IS NULL THEN
        SELECT id INTO fieldset_id FROM fieldsets.tokens WHERE token = NEW.token;
    ELSE
        fieldset_id := NEW.id;
    END IF;

    IF fieldset_id IS NULL THEN
        SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
        INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_id, NEW.token) ON CONFLICT DO NOTHING;
    END IF;

    NEW.id := fieldset_id;
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_create_fieldsets_partitions() IS
'/**
 * trigger_create_fieldsets_partitions: triggered before insert into data_values. Create a new data table if doesn''t exist and notify parent table to attach as partition.
 * @depends TRIGGER: create_fieldsets_partitions
 **/';