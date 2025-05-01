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
	values_record RECORD;
	object_record RECORD;
	insert_stmt TEXT := '';
	insert_values TEXT := '';
	insert_fieldset_values TEXT := '';
	insert_fields_sql TEXT := 'INSERT INTO fieldsets.fields (id, token, label, type, default_value, store, parent, parent_token, meta_data) VALUES';
	insert_sets_sql TEXT := 'INSERT INTO fieldsets.sets (id, token, label, parent, parent_token, meta_data) VALUES';
	insert_fieldsets_sql TEXT := 'INSERT INTO fieldsets.fieldsets (id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store) VALUES';
	field_values_sql TEXT;
	set_values_sql TEXT;
	fieldset_values_sql TEXT;
	set_id BIGINT;
	field_id BIGINT;
	field_parent_id BIGINT;
	field_parent_token TEXT;
	set_parent_id BIGINT;
	fieldset_id BIGINT;
	fieldset_child_id BIGINT;
	fieldset_parent_id BIGINT;
	fieldset_parent_token TEXT;
	fieldset_label TEXT;
	fieldset_token TEXT;
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
		insert_fieldset_values := '';
		fieldset_values_sql := '';

		FOR set_record IN
			SELECT
				value ->> 'token' AS token,
				value ->> 'label' AS label,
				COALESCE(value ->> 'parent', 'fieldset') AS parent,
				COALESCE(value ->> 'meta_data', '{}') AS meta_data
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
			set_values_sql := format('(%s, %L, %L, %s, %L, %L::JSONB)', set_id, set_record.token, set_record.label, set_parent_id, set_record.parent, set_record.meta_data);
			insert_values := format(E'%s\n%s,', insert_values, set_values_sql);

			-- Add fieldset ids to lookup table
			SELECT id INTO fieldset_parent_id FROM fieldsets.tokens WHERE token = set_record.parent;
			IF fieldset_parent_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_parent_id;
				INSERT INTO fieldsets.tokens(id, token) VALUES (fieldset_parent_id, set_record.parent) ON CONFLICT DO NOTHING;
			END IF;


			SELECT id INTO fieldset_id FROM fieldsets.tokens WHERE token = set_record.token;
			IF fieldset_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
				INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_id, set_record.token) ON CONFLICT DO NOTHING;
			END IF;

			fieldset_values_sql := format('(%s, %L, %L, %s, %L, %s, %L, %s, %L, %L::FIELD_TYPE, %L::STORE_TYPE)', fieldset_id, set_record.token, set_record.label, fieldset_parent_id, set_record.parent, set_id, set_record.token, 0, 'none', 'fieldset', 'fieldset');
			insert_fieldset_values := format(E'%s\n%s,', insert_fieldset_values, fieldset_values_sql);
		END LOOP;

		insert_stmt := format('%s %s,', insert_sets_sql, insert_values);
		insert_stmt := trim(TRAILING ',' FROM insert_stmt);
		EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);
		COMMIT;
		insert_stmt := format('%s %s,', insert_fieldsets_sql, insert_fieldset_values);
		insert_stmt := trim(TRAILING ',' FROM insert_stmt);
		EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);
		COMMIT;
		json_txt := fieldsets_record.data::TEXT;
		query_sql := format('SELECT * FROM fieldsets.parse_json_schema(%L);', json_txt);
		FOR json_record IN
			EXECUTE query_sql
		LOOP
			insert_stmt := '';
			insert_values := '';
			field_values_sql := '';

			-- Create Our Dynamic SQL Field insert statement
			-- Fields of type 'fieldset' & 'enum' have their parents reference the fieldset table. Switch the parent be self referencing.
			CASE json_record.field_type
				WHEN 'fieldset' THEN
					SELECT id INTO field_id FROM imported_fields WHERE token = json_record.field_token;
					IF field_id IS NULL THEN
						SELECT nextval('fieldsets.field_id_seq') INTO field_id;
						INSERT INTO imported_fields(token,id) VALUES (json_record.field_token, field_id);
					END IF;
					field_parent_id := field_id;
					field_parent_token := json_record.field_token;
				WHEN 'enum' THEN
					SELECT id INTO field_id FROM imported_fields WHERE token = json_record.field_token;
					IF field_id IS NULL THEN
						SELECT nextval('fieldsets.field_id_seq') INTO field_id;
						INSERT INTO imported_fields(token,id) VALUES (json_record.field_token, field_id);
					END IF;
					field_parent_id := field_id;
					field_parent_token := json_record.field_token;
				ELSE
					SELECT id INTO field_parent_id FROM imported_fields WHERE token = json_record.field_parent;
					field_parent_token := json_record.field_parent;
					IF field_parent_id IS NULL THEN
						SELECT nextval('fieldsets.field_id_seq') INTO field_parent_id;
						INSERT INTO imported_fields(token,id) VALUES (json_record.field_parent, field_parent_id);
					END IF;

					SELECT id INTO field_id FROM imported_fields WHERE token = json_record.field_token;
					IF field_id IS NULL THEN
						SELECT nextval('fieldsets.field_id_seq') INTO field_id;
						INSERT INTO imported_fields(token,id) VALUES (json_record.field_token, field_id);
					END IF;
			END CASE;

			default_field_value := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
			IF json_record.field_default_value IS NOT NULL THEN
				default_field_value := fieldsets.create_field_value(json_record.field_default_value, json_record.field_type);
			END IF;

			field_values_sql := format('(%s, %L, %L, %L::FIELD_TYPE, %L::FIELD_VALUE, %L::STORE_TYPE, %s, %L, %L::JSONB)', field_id, json_record.field_token, json_record.field_label, json_record.field_type::TEXT, default_field_value::TEXT, json_record.field_store::TEXT, field_parent_id, field_parent_token, json_record.field_meta_data::TEXT);
			insert_values := format(E'%s\n%s,', insert_values, field_values_sql);
			insert_stmt := format('%s %s', insert_fields_sql, insert_values);
			insert_stmt := trim(TRAILING ',' FROM insert_stmt);
			EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);
			COMMIT;

			insert_stmt := '';
			insert_values := '';
			fieldset_values_sql := '';

			-- Insert our fieldset schema data
			SELECT id INTO fieldset_id FROM fieldsets.tokens WHERE token = json_record.field_token;
			IF fieldset_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
				INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_id, json_record.field_token) ON CONFLICT DO NOTHING;
				COMMIT;
			END IF;
			SELECT id INTO set_id FROM imported_sets WHERE token = json_record.set_token;
			SELECT id INTO fieldset_parent_id FROM fieldsets.tokens WHERE token = json_record.field_parent;

			IF fieldset_parent_id IS NULL THEN
				fieldset_parent_id := fieldset_id;
				fieldset_parent_token := json_record.field_token;
			ELSIF json_record.field_type = 'fieldset' AND json_record.field_store <> 'fieldset' THEN
				fieldset_parent_id := fieldset_id;
				fieldset_parent_token := json_record.field_token;
			ELSE
				fieldset_parent_token := json_record.field_parent;
			END IF;

			INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_parent_id,fieldset_parent_token) ON CONFLICT DO NOTHING;
			COMMIT;

			fieldset_values_sql := format('(%s, %L, %L, %s, %L, %s, %L, %s, %L, %L::FIELD_TYPE, %L::STORE_TYPE)', fieldset_id, json_record.field_token, json_record.field_label, fieldset_parent_id, fieldset_parent_token, set_id, json_record.set_token, field_id, json_record.field_token, json_record.field_type::TEXT, json_record.field_store::TEXT);
			insert_values := format(E'%s\n%s,', insert_values, fieldset_values_sql);

			insert_stmt := format('%s %s', insert_fieldsets_sql, insert_values);
			insert_stmt := trim(TRAILING ',' FROM insert_stmt);

			EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);
			COMMIT;

			-- Manage ENUM field types
			insert_stmt := '';
			insert_values := '';
			fieldset_values_sql := '';
			IF (json_record.field_type = 'enum' OR (json_record.field_type = 'fieldset' AND json_record.field_store <> 'fieldset'))THEN
				CASE jsonb_typeof(json_record.field_values)
					WHEN 'string' THEN
						FOR values_record IN
							SELECT id,token,label FROM fieldsets.fieldsets WHERE parent_token = json_record.field_values::TEXT
						LOOP
							SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_child_id;
							fieldset_values_sql := format('(%s, %L, %L, %s, %L, %s, %L, %s, %L, %L::FIELD_TYPE, %L::STORE_TYPE)', fieldset_child_id, values_record.token, values_record.label, fieldset_id, json_record.field_token, set_id, json_record.set_token, field_id, json_record.field_token, 'fieldset', 'fieldset');
							insert_values := format(E'%s\n%s,', insert_values, fieldset_values_sql);
							INSERT INTO fieldsets.tokens(id,token) VALUES
								(fieldset_child_id,values_record.token)
							ON CONFLICT DO NOTHING;
							COMMIT;
						END LOOP;
					WHEN 'array' THEN
						FOR values_record IN
							SELECT * FROM jsonb_array_elements(json_record.field_values)
						LOOP
							IF json_typeof(to_json(values_record.value::JSON)) = 'object' THEN
								SELECT * INTO object_record FROM json_each_text(to_json(values_record.value::JSON));
								fieldset_label := object_record.value;
								SELECT id INTO fieldset_child_id FROM fieldsets.tokens WHERE token = object_record.key;
								IF fieldset_child_id IS NULL THEN
									SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_child_id;
									INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_child_id, object_record.key) ON CONFLICT DO NOTHING;
									COMMIT;
								END IF;
								fieldset_values_sql := format('(%s, %L, %L, %s, %L, %s, %L, %s, %L, %L::FIELD_TYPE, %L::STORE_TYPE)', fieldset_child_id, object_record.key, fieldset_label, fieldset_id, json_record.field_token, set_id, json_record.set_token, field_id, json_record.field_token, 'fieldset', 'fieldset');
								insert_values := format(E'%s\n%s,', insert_values, fieldset_values_sql);
								INSERT INTO fieldsets.tokens(id,token) VALUES
									(fieldset_child_id,object_record.key)
								ON CONFLICT DO NOTHING;
								COMMIT;
							ELSE
								-- Create a custom label for token
								SELECT trim(BOTH '"' FROM values_record.value::TEXT) INTO fieldset_token;
								fieldset_label := format('%s %s', fieldset_token, json_record.field_label);
								fieldset_label := initcap(fieldset_label);
								fieldset_label := trim(both ' ' from fieldset_label);
								SELECT id INTO fieldset_child_id FROM fieldsets.tokens WHERE token = fieldset_token;
								IF fieldset_child_id IS NULL THEN
									SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_child_id;
									INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_child_id, fieldset_token) ON CONFLICT DO NOTHING;
									COMMIT;
								END IF;
								fieldset_values_sql := format('(%s, %L, %L, %s, %L, %s, %L, %s, %L, %L::FIELD_TYPE, %L::STORE_TYPE)', fieldset_child_id, fieldset_token, fieldset_label, fieldset_id, json_record.field_token, set_id, json_record.set_token, field_id, json_record.field_token, 'fieldset', 'fieldset');
								insert_values := format(E'%s\n%s,', insert_values, fieldset_values_sql);
								INSERT INTO fieldsets.tokens(id,token) VALUES
									(fieldset_child_id,fieldset_token)
								ON CONFLICT DO NOTHING;
								COMMIT;
							END IF;
						END LOOP;
					ELSE
						insert_values := '';
				END CASE;

				IF insert_values <> '' THEN
					insert_stmt := format('%s %s', insert_fieldsets_sql, insert_values);
					insert_stmt := trim(TRAILING ',' FROM insert_stmt);

					EXECUTE format('%s ON CONFLICT DO NOTHING;', insert_stmt);
					COMMIT;
				END IF;
			END IF;
		END LOOP;

		UPDATE pipeline.imports SET imported = TRUE WHERE token = fieldsets_record.token AND type = 'schema' AND source = fieldsets_record.source AND priority = fieldsets_record.priority;
	END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_schemas() IS
'/**
 * import_json_schemas: takes a fieldset json schema found in the pipeine.imports table and insert it into fieldset tables.
 **/';
