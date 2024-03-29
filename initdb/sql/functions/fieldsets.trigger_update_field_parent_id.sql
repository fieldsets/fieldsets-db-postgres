/**
 * trigger_update_field_parent_id: triggered after insert. Set parent id equal to meta data parent_token
 * @depends TRIGGER: trigger_05_update_field_parent_id
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_update_field_parent_id()
RETURNS TRIGGER AS $function$
DECLARE
  update_sql TEXT;
  parent_id BIGINT;
BEGIN
  IF NEW.parent IS NULL THEN
    SELECT f.id INTO parent_id FROM fieldsets.fields f WHERE f.token = NEW.parent_token;
    IF parent_id >= 0 THEN
      update_sql := format('UPDATE fieldsets.fields SET parent = %s WHERE id = %s;', parent_id, NEW.id);
      NEW.parent := parent_id;
      EXECUTE update_sql;
    END IF;
  END IF;
  RETURN NEW;
END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_update_field_parent_id () IS
'/**
 * trigger_update_field_parent_id: triggered after insert. Set parent id equal to meta data parent_token
 * @depends TRIGGER: trigger_05_update_field_parent_id
 **/';
