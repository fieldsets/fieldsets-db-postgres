/**
 * trigger_20_create_sets_partitions: triggered after insert into sets table. Create a new data partition for the new id.
 * @depends trigger_create_sets_partitions FUNCTION (postgresql)
 **/
DROP TRIGGER IF EXISTS trigger_20_create_sets_partitions ON fieldsets.sets;
CREATE TRIGGER trigger_20_create_sets_partitions
AFTER INSERT ON fieldsets.sets
FOR EACH ROW
EXECUTE FUNCTION fieldsets.trigger_create_sets_partitions();


COMMENT ON TRIGGER trigger_20_create_sets_partitions ON fieldsets.sets IS '
/**
 * trigger_20_create_sets_partitions: triggered after insert into sets table. Create a new data partition for the new id.
 * @depends trigger_create_sets_partitions FUNCTION (postgresql)
 * @priority 20
 */';