/**
 * trigger_02_update_field_defaults: triggered before insert. If field parent token is not set, use store field as parent.
 * @depends FUNCTION: trigger_update_field_defaults
 **/
DROP TRIGGER IF EXISTS trigger_02_update_field_defaults ON fieldsets.fields;
CREATE TRIGGER trigger_02_update_field_defaults
	BEFORE INSERT ON fieldsets.fields
	FOR EACH ROW
	WHEN (NEW.parent_token IS NULL)
	EXECUTE FUNCTION fieldsets.trigger_update_field_defaults();

COMMENT ON TRIGGER trigger_02_update_field_defaults ON fieldsets.fields IS '
/**
 * trigger_02_update_field_defaults: triggered before insert. If field parent token is not set, use store field as parent.
 * @depends FUNCTION: trigger_update_field_defaults
 * @priority 2
 */';
