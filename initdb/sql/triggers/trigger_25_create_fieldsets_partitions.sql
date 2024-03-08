/**
 * trigger_25_create_fieldsets_partitions: triggered after insert into fieldsets table. Create a new data partition for the new parent token/field_parent_token.
 * @depends trigger_create_fieldsets_partitions FUNCTION (postgresql)
 **/
/*
DROP TRIGGER IF EXISTS trigger_25_create_fieldsets_partitions ON fieldsets.fieldsets;
CREATE TRIGGER trigger_25_create_fieldsets_partitions
BEFORE INSERT ON fieldsets.fieldsets
FOR EACH ROW
EXECUTE FUNCTION fieldsets.trigger_create_fieldsets_partitions();


COMMENT ON TRIGGER trigger_25_create_fieldsets_partitions ON fieldsets.fieldsets IS
'/**
 * trigger_25_create_fieldsets_partitions: triggered after insert into fieldsets table. Create a new data partition for the new parent token/field_parent_token.
 * @depends trigger_create_fieldsets_partitions FUNCTION (postgresql)
 * @priority 25
 */';
 */