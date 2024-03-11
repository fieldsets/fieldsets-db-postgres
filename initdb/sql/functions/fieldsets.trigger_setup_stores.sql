/**
 * trigger_setup_stores: triggered after insert into fieldsets table. Setup all stores for values inserted.
 * @depends TRIGGER: trigger_30_setup_stores
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_setup_stores() RETURNS trigger AS $function$
  DECLARE
    sql_stmt TEXT;
    store_tbl_name TEXT;
    store_col_name TEXT;
    partition_name TEXT;
    fieldset_records RECORD;
    col_data_type TEXT;
  BEGIN
    FOR fieldset_records IN
      SELECT
        id,
        token,
        parent,
        parent_token,
        set_id,
        field_id,
        type,
        store
      FROM new_fieldsets
      WHERE parent > 1
    LOOP
      RAISE NOTICE 'Fieldset: (%,%,%,%,%,%,%,%)', fieldset_records.id, fieldset_records.token, fieldset_records.parent, fieldset_records.parent_token, fieldset_records.set_id, fieldset_records.field_id, fieldset_records.type, fieldset_records.store;
      IF fieldset_records.store = 'filter' THEN
        partition_name := format('__%s_%s', fieldset_records.store, fieldset_records.parent_token);
        store_tbl_name := 'filters';
        sql_stmt := format('CREATE TABLE IF NOT EXISTS fieldsets.%I(CHECK(parent=%s)) INHERITS (fieldsets.%I) TABLESPACE %I;', partition_name, fieldset_records.parent, store_tbl_name, store_tbl_name);
        EXECUTE sql_stmt;
        SELECT fieldsets.get_field_data_type(fieldset_records.type::TEXT) INTO col_data_type;
        sql_stmt := format('ALTER TABLE fieldsets.%I ADD COLUMN IF NOT EXISTS %s %s;', partition_name, col_data_type, fieldset_records.token);
        EXECUTE sql_stmt;
      ELSIF fieldset_records.store = 'record' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'document' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'lookup' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'message' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'sequence' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'view' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'file' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'program' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'custom' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSIF fieldset_records.store = 'none' THEN
        sql_stmt := format('ALTER TABLE fieldsets');
      ELSE --'any' type
        sql_stmt := format('ALTER TABLE fieldsets');
      END IF;
    END LOOP;
    RETURN NULL;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_setup_stores() IS
'/**
 * trigger_setup_stores: triggered after insert into fieldsets table. Setup all stores for values inserted.
 * @depends TRIGGER: trigger_30_setup_stores
 **/';