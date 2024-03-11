/**
 * import_json_schemas: takes a fieldset json schema found in the pipeine.imports table and insert it into fieldset tables.
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_schemas() AS $procedure$
DECLARE
	fieldsets_record RECORD;
	set_record RECORD;
	field_record RECORD;
	default_field_value FIELD_VALUE;
	query_sql TEXT;
	json_txt TEXT;
	json_record RECORD;
	insert_stmt TEXT := '';
	insert_values TEXT := '';
	insert_fields_sql TEXT := 'INSERT INTO fieldsets.fields (id, token, label, type, default_value, store, parent, parent_token, meta) VALUES';
	insert_sets_sql TEXT := 'INSERT INTO fieldsets.sets (id, token, label, parent, parent_token, meta) VALUES';
	insert_fieldsets_sql TEXT := 'INSERT INTO fieldsets.fieldsets (id, token, parent, parent_token, set_id, field_id, type, store) VALUES';
	field_values_sql TEXT;
	set_values_sql TEXT;
	fieldset_values_sql TEXT;
	set_id BIGINT;
	field_id BIGINT;
	fieldset_id BIGINT;
	field_parent_id BIGINT;
	set_parent_id BIGINT;
	fieldset_parent_id BIGINT;
BEGIN
	DROP TABLE IF EXISTS imported_fields;
	CREATE TEMPORARY TABLE imported_fields(
		token TEXT NOT NULL UNIQUE PRIMARY KEY,
		id BIGINT
	);
	INSERT INTO imported_fields (token,id) SELECT token, id FROM fieldsets.fields;

	DROP TABLE IF EXISTS imported_sets;
	CREATE TEMPORARY TABLE imported_sets(
		token TEXT NOT NULL UNIQUE PRIMARY KEY,
		id BIGINT
	);
	INSERT INTO imported_sets(token,id) SELECT token, id FROM fieldsets.sets;

	DROP TABLE IF EXISTS imported_fieldsets;
	CREATE TEMPORARY TABLE imported_fieldsets(
		token TEXT NOT NULL UNIQUE PRIMARY KEY,
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
		WHERE type='schema' AND imported = FALSE
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
			SELECT id INTO set_parent_id FROM imported_sets WHERE token = set_record.parent;
			IF set_parent_id IS NULL THEN
				SELECT nextval('fieldsets.set_id_seq') INTO set_parent_id;
				INSERT INTO imported_sets(token,id) VALUES (set_record.parent, set_parent_id);
			END IF;

			SELECT id INTO set_id FROM imported_sets WHERE token = set_record.token;
			IF set_id IS NULL THEN
				SELECT nextval('fieldsets.set_id_seq') INTO set_id;
				INSERT INTO imported_sets(token,id) VALUES (set_record.token, set_id);
			END IF;

			-- Create Dynamic Set SQL
			set_values_sql := format('(%s, %L, %L, %s, %L, %L::JSONB)', set_id, set_record.token, set_record.label, set_parent_id, set_record.parent, set_record.metadata);
			insert_values := format(E'%s\n%s,', insert_values, set_values_sql);

			-- Add fieldset ids to lookup table
			SELECT id INTO fieldset_parent_id FROM imported_fieldsets WHERE token = set_record.parent;
			IF fieldset_parent_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_parent_id;
				INSERT INTO imported_fieldsets(token,id) VALUES (set_record.parent, fieldset_parent_id);
			END IF;

			SELECT id INTO fieldset_id FROM imported_fieldsets WHERE token = set_record.token;
			IF fieldset_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
				INSERT INTO imported_fieldsets(token,id) VALUES (set_record.token, fieldset_id);
			END IF;

		END LOOP;

		insert_stmt := format('%s %s,', insert_sets_sql, insert_values);
		insert_stmt := trim(TRAILING ',' FROM insert_stmt);
		EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);

		json_txt := fieldsets_record.data::TEXT;
		query_sql := format('SELECT * FROM fieldsets.parse_json_schema(%L);', json_txt);
		FOR json_record IN
			EXECUTE query_sql
		LOOP
			insert_stmt := '';
			insert_values := '';
			field_values_sql := '';

			-- Create Our Dynamic SQL Field insert statement 
			SELECT id INTO field_parent_id FROM imported_fields WHERE token = json_record.field_parent;
			IF field_parent_id IS NULL THEN
				SELECT nextval('fieldsets.field_id_seq') INTO field_parent_id;
				INSERT INTO imported_fields(token,id) VALUES (json_record.field_parent, field_parent_id);
			END IF;

			SELECT id INTO field_id FROM imported_fields WHERE token = json_record.field_token;
			IF field_id IS NULL THEN
				SELECT nextval('fieldsets.field_id_seq') INTO field_id;
				INSERT INTO imported_fields(token,id) VALUES (json_record.field_token, field_id);
			END IF;

			default_field_value := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
			IF json_record.field_default_value IS NOT NULL THEN
				default_field_value := fieldsets.create_field_value(json_record.field_default_value, json_record.field_type);
			END IF;

			field_values_sql := format('(%s, %L, %L, %L::FIELD_TYPE, %L::FIELD_VALUE, %L::STORE_TYPE, %s, %L, %L::JSONB)', field_id, json_record.field_token, json_record.field_label, json_record.field_type::TEXT, default_field_value::TEXT, json_record.field_store::TEXT, field_parent_id, json_record.field_parent, json_record.field_metadata::TEXT);
			insert_values := format(E'%s\n%s,', insert_values, field_values_sql);
			insert_stmt := format('%s %s', insert_fields_sql, insert_values);
			insert_stmt := trim(TRAILING ',' FROM insert_stmt);
			EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);

			insert_stmt := '';
			insert_values := '';
			fieldset_values_sql := '';
			-- Insert our fieldset schema data
			SELECT id INTO fieldset_parent_id FROM imported_fieldsets WHERE token = json_record.set_parent;
			SELECT id INTO set_parent_id FROM imported_sets WHERE token = json_record.set_parent;
			SELECT id INTO fieldset_id FROM imported_fieldsets WHERE token = json_record.set_token;
			SELECT id INTO set_id FROM imported_sets WHERE token = json_record.set_token;

			fieldset_values_sql := format('(%s, %L, %s, %L, %s, %s, %L::FIELD_TYPE, %L::STORE_TYPE)', fieldset_id, json_record.set_token, fieldset_parent_id, json_record.set_parent, set_id, field_id, json_record.field_type::TEXT, json_record.field_store::TEXT);
			insert_values := format(E'%s\n%s,', insert_values, fieldset_values_sql);
			insert_stmt := format('%s %s', insert_fieldsets_sql, insert_values);
			insert_stmt := trim(TRAILING ',' FROM insert_stmt);

			EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);
		END LOOP;

		UPDATE pipeline.imports SET imported = TRUE WHERE token = fieldsets_record.token AND type = 'schema' AND source = fieldsets_record.source AND priority = fieldsets_record.priority;
	END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_schemas() IS
'/**
 * import_json_schemas: takes a fieldset json schema found in the pipeine.imports table and insert it into fieldset tables.
 **/';
