/**
 * trigger_04_create_new_imports_partition: triggered before insert into pipeline.imports table. Create a new partition for the token and create date partitions using the month of the current year if it does not exist using the `created` field.
 *
 * @depends FUNCTION: pipeline.trigger_create_new_imports_partition
 **/
CREATE OR REPLACE TRIGGER trigger_04_create_new_imports_partition
BEFORE INSERT ON pipeline.__imports_default
FOR EACH ROW
EXECUTE FUNCTION pipeline.trigger_create_new_imports_partition();

COMMENT ON TRIGGER trigger_04_create_new_imports_partition ON pipeline.__imports_default IS '
/**
 * trigger_04_create_new_imports_partition: triggered before insert into pipeline.imports table. Create a new partition for the token and create date partitions using the month of the current year if it does not exist using the `created` field.
 * @depends FUNCTION: pipeline.trigger_create_new_imports_partition
 * @priority 4
 **/'