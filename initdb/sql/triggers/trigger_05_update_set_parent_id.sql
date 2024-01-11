/**
 * trigger_05_update_set_parent_id: triggered after insert to set parent id equal to parent_token.
 * @depends FUNCTION: trigger_update_set_parent_id
 **/
DROP TRIGGER IF EXISTS trigger_05_update_set_parent_id ON fieldsets.sets;
CREATE TRIGGER trigger_05_update_set_parent_id
	AFTER INSERT ON fieldsets.sets
	FOR EACH ROW
	WHEN (NEW.parent IS NULL)
	EXECUTE FUNCTION fieldsets.trigger_update_set_parent_id();

COMMENT ON TRIGGER trigger_05_update_set_parent_id ON fieldsets.sets IS '
/**
 * trigger_05_update_set_parent_id: triggered after insert to set parent id equal to parent_token
 * @depends FUNCTION: trigger_update_set_parent_id
 * @priority 5
 */';
