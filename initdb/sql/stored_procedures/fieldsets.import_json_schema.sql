-- Active: 1692635254843@@0.0.0.0@5432@fieldsets
/**
 * import_json_schema: take a fieldset json schema and insert it into fieldset tables.
 * @param TEXT: json_string
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_schema(json_string TEXT) AS $procedure$
    DECLARE
        set_insert_sql TEXT;
        field_insert_sql TEXT;
        values_insert_sql TEXT;
        field_value_col_sql TEXT;
        set_record RECORD;
        field_record RECORD;
        current_token TEXT;
        meta_json_sql TEXT;
    BEGIN
        set_insert_sql := 'INSERT INTO fieldsets.sets (id, token, label, parent, default_store, meta) VALUES';
        FOR set_record IN
            SELECT DISTINCT
                set_token,
                set_label,
                set_parent,
                set_default_store
            FROM fieldsets.parse_json_schema(json_string) json_schema
        LOOP
            current_token := set_record.set_token;
            IF set_record.set_token IS NULL THEN
                current_token := format('%s_%s', set_record.set_parent, set_record.set_default_store);
            END IF;
            meta_json_sql := format('{"parent_token": "%s"}', set_record.set_parent);
            values_insert_sql := format('(%s, %L, %L, %s, %L, %L::JSONB),', nextval('fieldsets.set_id_seq'), current_token, set_record.set_label, 0, set_record.set_default_store, meta_json_sql);
            set_insert_sql := format('%s %s', set_insert_sql, values_insert_sql);
        END LOOP;
        set_insert_sql := TRIM(TRAILING ',' FROM set_insert_sql);
        RAISE NOTICE 'EXECUTING SQL: %', set_insert_sql;
        EXECUTE set_insert_sql;

        FOR field_record IN
            SELECT
                field_token,
                field_label,
                field_type,
                field_store,
                field_parent,
                field_default_value
            FROM fieldsets.parse_json_schema(json_string) json_schema
        LOOP
            current_token := field_record.field_token;
            IF field_record.field_token IS NULL THEN
                current_token := format('%s_%s', field_record.field_parent, field_record.field_store);
            END IF;
            field_value_col_sql := format('default_value.%s', field_record.field_type);
            meta_json_sql := format('{"parent_token": "%s"}', field_record.field_parent);
            values_insert_sql := format('(%s, %L, %L, %L, %L, %s, %L, %L::JSONB)', nextval('fieldsets.field_id_seq'), current_token, field_record.field_label, field_record.field_type, field_record.field_store, 0, field_record.field_default_value, meta_json_sql);
            field_insert_sql := format('INSERT INTO fieldsets.fields (id, token, label, type, store, parent, %s, meta) VALUES %s', field_value_col_sql, values_insert_sql);
            RAISE NOTICE 'EXECUTING SQL: %', field_insert_sql;
            EXECUTE field_insert_sql;
        END LOOP;


    END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_schema(TEXT) IS
'/**
 * import_json_schema: take a fieldset json schema and insert it into fieldset tables.
 * @param TEXT: json_string
 **/';
