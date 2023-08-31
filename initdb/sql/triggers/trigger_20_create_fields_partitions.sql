/**
 * trigger_20_create_fields_partitions: triggered after insert into fields table. Create a new data partition for the new id.
 * @depends trigger_create_fields_partitions FUNCTION (postgresql)
 **/
DROP TRIGGER IF EXISTS trigger_20_create_fields_partitions ON fieldsets.fields;
CREATE TRIGGER trigger_20_create_fields_partitions
AFTER INSERT ON fieldsets.fields
FOR EACH ROW 
EXECUTE FUNCTION trigger_create_fields_partitions();


COMMENT ON TRIGGER trigger_20_create_fields_partitions ON fieldsets.fields IS '
/**
 * trigger_20_create_fields_partitions: triggered after insert into fields table. Create a new data partition for the new id.
 * @depends trigger_create_fields_partitions FUNCTION (postgresql)
 * @priority 20
 */';