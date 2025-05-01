/**
 * trigger_11_insert_fieldset_token: triggered before insert into fieldsets table. Create a new token entry if it does not exist.
 * @depends trigger_insert_fieldset_token FUNCTION (postgresql)
 **/
CREATE OR REPLACE TRIGGER trigger_11_insert_fieldset_token
BEFORE INSERT ON fieldsets.fieldsets
FOR EACH ROW
EXECUTE FUNCTION fieldsets.trigger_insert_fieldset_token();

COMMENT ON TRIGGER trigger_11_insert_fieldset_token ON fieldsets.fieldsets IS
'/**
  * trigger_11_insert_fieldset_token: triggered before insert into fieldsets table. Create a new token entry if it does not exist.
 * @depends trigger_insert_fieldset_token FUNCTION (postgresql)
 * @priority 11
 */';