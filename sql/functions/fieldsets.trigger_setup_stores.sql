/**
 * trigger_setup_stores: triggered after insert into fieldsets table. Setup all stores for values inserted.
 * @depends TRIGGER: trigger_30_setup_stores
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_setup_stores() RETURNS trigger AS $function$
  DECLARE
    fieldset_records RECORD;
    store_token TEXT;
    current_set_token TEXT;
    partition_ids BIGINT[];
    fs_record FIELDSET_RECORD;
    fs_child_records FIELDSET_RECORD[];
    proc_name TEXT;
    sql_stmt TEXT;
    exists_check BOOLEAN;
  BEGIN
    FOR fieldset_records IN
      WITH partition_parents AS (
        SELECT
          A.parent,
          A.set_id,
          A.set_token,
          A.store
        FROM fieldsets.fieldsets A,
        new_fieldsets B
        WHERE A.store <> 'fieldset'
        AND B.store = 'fieldset'
        AND A.set_id = B.set_id
        UNION
        SELECT
          A.parent,
          A.set_id,
          A.set_token,
          A.store
        FROM fieldsets.fieldsets A,
        fieldsets.fieldsets B
        WHERE A.store <> 'fieldset'
        AND B.store = 'fieldset'
        AND A.set_id = B.set_id
        UNION
        SELECT
          parent,
          set_id,
          set_token,
          store
        FROM new_fieldsets
        WHERE store <> 'fieldset'
        UNION
        SELECT
          parent,
          set_id,
          set_token,
          store
        FROM fieldsets.fieldsets
        WHERE store <> 'fieldset'
      )
      SELECT
        A.set_id,
        A.set_token,
        B.store,
        array_agg(DISTINCT B.parent) AS ids
      FROM  new_fieldsets A,
        partition_parents B
      WHERE A.set_id = B.set_id
      AND B.parent <> 1
      GROUP BY A.set_id, A.set_token, B.store
    LOOP
      store_token := fieldset_records.store;
      current_set_token := fieldset_records.set_token;
      partition_ids := fieldset_records.ids;

      SELECT id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store
      INTO fs_record
      FROM fieldsets.fieldsets
      WHERE token = current_set_token;

      -- Create an array of fieldset records that we are going to use to setup the stores.
      -- We then call functions that can be overwritten to handle the different store type for other data solutions.
      SELECT array_agg(ROW(id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store)::FIELDSET_RECORD)
      INTO fs_child_records
      FROM fieldsets.fieldsets
      WHERE id IN (SELECT unnest(partition_ids));

      /**
       * Execute the store procedure setup_${STORE_TOKEN}_store if it exists.
       */
      exists_check := FALSE;
      proc_name := format('setup_%s_store', store_token);
      SELECT public.procedure_exists('fieldsets', proc_name) INTO exists_check;
      IF exists_check THEN
        sql_stmt := format('CALL fieldsets.%I(%L, %L)', proc_name, fs_record, fs_child_records);
        EXECUTE sql_stmt;
      END IF;

      /**
       * Allow a secondary procedure call pos_setup_${STORE_TOKEN}_store if it exists. This keeps DB tables in place when desired.
       */
      exists_check := FALSE;
      proc_name := format('post_setup_%s_store', store_token);
      SELECT public.procedure_exists('fieldsets', proc_name) INTO exists_check;
      IF exists_check THEN
        sql_stmt := format('CALL fieldsets.%I(%L, %L)', proc_name, fs_record, fs_child_records);
        EXECUTE sql_stmt;
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