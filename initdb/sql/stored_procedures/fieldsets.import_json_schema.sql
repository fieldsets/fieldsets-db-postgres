-- Active: 1692635254843@@0.0.0.0@5432@fieldsets
/**
 * import_json_schema: take a fieldset json schema and insert it into fieldset tables.
 * @param TEXT: json_string
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_schema(json_string TEXT) AS $procedure$
    DECLARE
        constraint_sql TEXT;
        set_insert_sql TEXT;
        field_insert_sql TEXT;
        values_insert_sql TEXT;
        field_value_col_sql TEXT;
        set_record RECORD;
        field_record RECORD;
        current_token TEXT;
        meta_json_sql TEXT := '{}';
    BEGIN
        constraint_sql := 'ALTER TABLE fieldsets.sets DROP CONSTRAINT IF EXISTS sets_parent_fkey CASCADE;';
        EXECUTE constraint_sql;
        constraint_sql := 'ALTER TABLE fieldsets.fields DROP CONSTRAINT IF EXISTS fields_parent_fkey CASCADE;';
        EXECUTE constraint_sql;

        set_insert_sql := 'INSERT INTO fieldsets.sets (id, token, label, parent, parent_token, default_store, meta) VALUES';
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
            values_insert_sql := format('(%s, %L, %L, %s, %L, %L, %L::JSONB),', nextval('fieldsets.set_id_seq'), current_token, set_record.set_label, 'NULL', set_record.set_parent, set_record.set_default_store, meta_json_sql);
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
            values_insert_sql := format('(%s, %L, %L, %L, %s, %L, %L, %L::JSONB)', nextval('fieldsets.field_id_seq'), current_token, field_record.field_label, field_record.field_type, field_record.field_store, 'NULL', field_record.field_parent, field_record.field_default_value, meta_json_sql);
            field_insert_sql := format('INSERT INTO fieldsets.fields (id, token, label, type, parent, parent_token, %s, meta) VALUES %s', field_value_col_sql, values_insert_sql);
            RAISE NOTICE 'EXECUTING SQL: %', field_insert_sql;
            EXECUTE field_insert_sql;
        END LOOP;

        constraint_sql := 'ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_parent_fkey FOREIGN KEY (parent) REFERENCES fieldsets.sets(id) INITIALLY DEFERRED;';
        --EXECUTE constraint_sql;
        constraint_sql := 'ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_parent_fkey FOREIGN KEY (parent) REFERENCES fieldsets.fields(id) INITIALLY DEFERRED;';
        --EXECUTE constraint_sql;

    END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_schema(TEXT) IS
'/**
 * import_json_schema: take a fieldset json schema and insert it into fieldset tables.
 * @param TEXT: json_string
 **/';


/**
DO $$ DECLARE
	fieldsets_record RECORD;
	set_record RECORD;
	field_record RECORD;
	query_sql TEXT;
	json_txt TEXT;
	json_record RECORD;
	insert_stmt TEXT := '';
	insert_values TEXT := '';
	insert_fields_sql TEXT := 'INSERT INTO fieldsets.fields (id, token, label, type, default_value, store, parent, parent_token, meta) VALUES';
	insert_sets_sql TEXT := 'INSERT INTO fieldsets.sets (id, token, label, parent, parent_token, meta) VALUES';
	insert_fieldsets_sql TEXT := 'INSERT INTO fieldsets.fieldsets (id, token, parent, parent_token, set_id, set_token, set_parent, set_parent_token, field_id, field_token, field_parent, field_parent_token, meta) VALUES';
	field_values_sql TEXT;
	set_values_sql TEXT;
	fieldset_values_sql TEXT;
	set_id BIGINT;
	field_id BIGINT;
	fieldset_id BIGINT;
	parent_id BIGINT;
BEGIN
	DROP TABLE IF EXISTS imported_fields;
	CREATE TEMPORARY TABLE imported_fields(
		token TEXT,
		id BIGINT
	);
	INSERT INTO imported_fields (token,id) SELECT token, id FROM fieldsets.fields;


	DROP TABLE IF EXISTS imported_sets;
	CREATE TEMPORARY TABLE imported_sets(
		token TEXT,
		id BIGINT
	);
	INSERT INTO imported_sets(token,id) SELECT token, id FROM fieldsets.sets;

	DROP TABLE IF EXISTS imported_fieldsets;
	CREATE TEMPORARY TABLE imported_fieldsets(
		token TEXT,
		id BIGINT
	);
	INSERT INTO imported_fieldsets(token,id) SELECT token, id FROM fieldsets.fieldsets;
	
	FOR fieldsets_record IN
		SELECT 
			token, 
			source, 
			type, 
			priority, 
			data 
		FROM pipeline.imports 
		WHERE type='schema' AND imported IS FALSE
		ORDER BY priority
	LOOP
		insert_stmt := '';
		insert_values := '';
		set_values_sql := '';
		FOR set_record IN
			SELECT 
				value ->> 'token' AS token, 
				value ->> 'label' AS label, 
				COALESCE(value ->> 'parent', 'fieldset') AS parent, 
				COALESCE(value ->> 'metadata', '{}') AS metadata 
				FROM jsonb_array_elements(fieldsets_record.data)
		LOOP
			-- Lookup set ids
			SELECT id INTO parent_id FROM imported_sets WHERE token = set_record.parent;
			IF parent_id IS NULL THEN
				SELECT nextval('fieldsets.set_id_seq') INTO parent_id;
				INSERT INTO imported_sets(token,id) VALUES (set_record.parent, parent_id);
			END IF;
		
			SELECT id INTO set_id FROM imported_sets WHERE token = set_record.token;
			IF set_id IS NULL THEN
				SELECT nextval('fieldsets.set_id_seq') INTO set_id;
				INSERT INTO imported_sets(token,id) VALUES (set_record.token, set_id);
			END IF;
		
			-- Create Dynamic Set SQL
			set_values_sql := format('(%s, %L, %L, %s, %L, %L::JSONB)', set_id, set_record.token, set_record.label, parent_id, set_record.parent, set_record.metadata);
			insert_values := format('%s\n%s', insert_values, set_values_sql);
		
			-- Add fieldset ids to lookup table
			SELECT id INTO parent_id FROM imported_fieldsets WHERE token = set_record.parent;
			IF parent_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO parent_id;
				INSERT INTO imported_fieldsets(token,id) VALUES (set_record.parent, parent_id);
			END IF;
		
			SELECT id INTO fieldset_id FROM imported_fieldsets WHERE token = set_record.token;
			IF fieldset_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
				INSERT INTO imported_sets(token,id) VALUES (set_record.token, fieldset_id);
			END IF;
		
		END LOOP;
		
		insert_stmt := format('%s %s\nON CONFLICT DO NOTHING', insert_sets_sql, insert_values);
		RAISE NOTICE 'SET INSERT SQL: %', insert_stmt;

		json_txt := fieldsets_record.data::TEXT;
		query_sql := format('SELECT * FROM fieldsets.parse_json_schema(%L);', json_txt);
		FOR json_record IN
			EXECUTE query_sql
		LOOP
			insert_stmt := '';
			insert_values := '';
			field_values_sql := '';
		
			-- Create Our Dynamic SQL Field insert statement 
			SELECT id INTO parent_id FROM imported_fields WHERE token = json_record.field_parent;
			IF parent_id IS NULL THEN
				SELECT nextval('fieldsets.field_id_seq') INTO parent_id;
				INSERT INTO imported_fields(token,id) VALUES (json_record.field_parent, parent_id);
			END IF;
		
			SELECT id INTO field_id FROM imported_fields WHERE token = json_record.field_token;
			IF field_id IS NULL THEN
				SELECT nextval('fieldsets.field_id_seq') INTO field_id;
				INSERT INTO imported_fields(token,id) VALUES (json_record.field_token, field_id);
			END IF;
			
			field_values_sql := format('(%s, %L, %L, %L, %L, %L, %s, %L, %L::JSONB)', field_id, json_record.field_token, json_record.field_label, json_record.field_type, json_record.field_default_value::TEXT, json_record.field_store, parent_id, json_record.field_parent, json_record.field_metadata::TEXT);
			insert_values := format('%s\n%s', insert_values, field_values_sql);
			insert_stmt := format('%s %s\nON CONFLICT DO NOTHING', insert_fields_sql, insert_values);		
			RAISE NOTICE 'FIELD INSERT  SQL: %', insert_stmt;
			
		
			
		END LOOP;		
	END LOOP;	
END $$;



**/