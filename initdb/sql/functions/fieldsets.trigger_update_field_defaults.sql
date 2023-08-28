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
    IF NEW.type = 'fieldset'::FIELD_TYPE THEN
      SELECT f.id INTO parent_id FROM fieldsets.fields f WHERE f.token = NEW.store;
    ELSE
      SELECT f.id INTO parent_id FROM fieldsets.fields f WHERE f.token = NEW.parent_token;
    END IF;

    IF parent_id >= 0 THEN
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
