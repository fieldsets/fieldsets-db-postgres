/**
 * trigger_20_create_fieldsets_partitions: triggered after insert into sets table. Create a new data partition for the new id.
 * @depends trigger_create_fieldsets_partitions FUNCTION (postgresql)
 **/
CREATE OR REPLACE TRIGGER trigger_20_create_fieldsets_partitions
BEFORE INSERT ON fieldsets.sets
FOR EACH ROW
EXECUTE FUNCTION fieldsets.trigger_create_fieldsets_partitions();

COMMENT ON TRIGGER trigger_20_create_fieldsets_partitions ON fieldsets.sets IS
'/**
 * trigger_20_create_fieldsets_partitions: triggered after insert into sets table. Create a new data partition for the new id.
 * @depends trigger_create_fieldsets_partitions FUNCTION (postgresql)
 * @priority 20
 */';