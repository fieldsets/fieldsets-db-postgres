/**
 * trigger_32_create_enum_data_type: triggered after insert into enum table. Create or update enumerated data type.
 * @depends FUNCTION: trigger_create_enum_data_type
 * @priority 32
 **/
CREATE OR REPLACE TRIGGER trigger_32_create_enum_data_type
AFTER INSERT ON fieldsets.enums
FOR EACH ROW
EXECUTE FUNCTION fieldsets.trigger_create_enum_data_type();

COMMENT ON TRIGGER trigger_32_create_enum_data_type ON fieldsets.enums IS
'/**
 * trigger_32_create_enum_data_type: triggered after insert into enum table. Create or update enumerated data type.
 * @depends FUNCTION: trigger_create_enum_data_type
 * @priority 32
 */';