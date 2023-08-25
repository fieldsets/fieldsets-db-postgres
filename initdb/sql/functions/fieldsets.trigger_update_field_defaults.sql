/**
 * trigger_update_field_defaults: triggered before insert. If field parent token is not set, use store field as parent.
 * @depends TRIGGER: trigger_02_update_field_defaults
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_update_field_defaults()
RETURNS TRIGGER AS $function$
  DECLARE
    parent_id BIGINT;
  BEGIN
    IF NEW.parent_token IS NULL THEN
      NEW.parent_token := NEW.store::TEXT;
    END IF;
    SELECT f.parent INTO parent_id FROM fieldsets.fields f WHERE f.token = NEW.token;
    IF parent_id > 0 THEN
      NEW.parent := parent_id;
    END IF;
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_update_field_defaults () IS
'/**
 * trigger_update_field_defaults: triggered before insert. If field parent token is not set, use store field as parent.
 * @depends TRIGGER: trigger_02_update_field_defaults
 **/';
