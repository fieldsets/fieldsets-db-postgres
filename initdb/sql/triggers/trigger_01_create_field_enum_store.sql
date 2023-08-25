/**
 * trigger_01_create_field_enum_store: triggered before insert. If field store is an enum, take the values and create it in PG.
 * @depends FUNCTION: trigger_create_field_enum_store
 **/
DROP TRIGGER IF EXISTS trigger_01_create_field_enum_store ON fieldsets.fields;
CREATE TRIGGER trigger_01_create_field_enum_store
	BEFORE INSERT ON fieldsets.fields
	FOR EACH ROW
	WHEN (NEW.store = 'enum')
	EXECUTE FUNCTION fieldsets.trigger_create_field_enum_store();

COMMENT ON TRIGGER trigger_01_create_field_enum_store ON fieldsets.fields IS '
/**
 * trigger_01_create_field_enum_store: triggered before insert. If field store is an enum, take the values and create it in PG.
 * @depends FUNCTION: trigger_create_field_enum_store
 * @priority 1
 */';
