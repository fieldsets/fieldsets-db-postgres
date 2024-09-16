/**
 * import_json_data: takes a fieldset json data found in the pipeine.imports table and insert it into corresponding tables.
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_data() AS $procedure$
DECLARE
	json_record RECORD;
	json_path TEXT[];
	json_data JSONB;
	data_record RECORD;
	insert_stmt TEXT := '';
	stores_insert_stmt TEXT := '';
	field_record RECORD;
	field_name TEXT;
	field_value TEXT;
	typed_field_value FIELD_VALUE;
	json_fields RECORD;
	json_field_value JSONB;
	json_field_data_type TEXT;
	json_array_count INT;
	escaped_field_value TEXT;
	trimmed_field_value TEXT;
	field_data_type TEXT;
	set_record RECORD;
	set_parent_record RECORD;
	set_parent_id BIGINT;
	fieldset_parent_token TEXT;
	fieldset_record RECORD;
	fieldset_parent_record RECORD;
	fieldset_id BIGINT;
	fieldset_token TEXT;
	fieldset_parent_id BIGINT;
	fieldset_label TEXT;
	fieldset_created_date TEXT;
	fieldset_created_timestamp TIMESTAMPTZ;
	stream_data TEXT;
	stack TEXT;
BEGIN
	FOR data_record IN
		SELECT
			token,
			source,
			type,
			priority,
			data
		FROM pipeline.imports
		WHERE type='data' AND imported = FALSE
		ORDER BY priority
	LOOP
		insert_stmt := '';

		SELECT id INTO set_parent_id FROM fieldsets.sets WHERE token = data_record.token;

		FOR json_record IN
			SELECT
				value
			FROM jsonb_array_elements(data_record.data)
		LOOP
			fieldset_parent_token := json_record.value->>'parent';
			fieldset_token := json_record.value->>'token';
			fieldset_label := json_record.value->>'label';
			-- Expecting ISO 8601 String Format
			fieldset_created_date := json_record.value->>'created';
			IF fieldset_created_date IS NULL THEN
				fieldset_created_timestamp := NOW();
			ELSE
				fieldset_created_timestamp := fieldset_created_date::TIMESTAMPTZ;
			END IF;

			-- Make sure sets and their partition tables are created.
			SELECT id, token INTO set_parent_record FROM fieldsets.sets WHERE token = fieldset_parent_token;

			SELECT id, token INTO set_record FROM fieldsets.sets WHERE token = fieldset_token;

			SELECT id, token INTO field_record FROM fieldsets.fields WHERE token = fieldset_token;
			SELECT id, token INTO fieldset_parent_record FROM fieldsets.tokens WHERE token = fieldset_parent_token;

			SELECT id INTO fieldset_id FROM fieldsets.tokens WHERE token = fieldset_token;
			IF fieldset_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
				INSERT INTO fieldsets.tokens(id,token) VALUES (fieldset_id,fieldset_token) ON CONFLICT DO NOTHING;
				COMMIT;
				insert_stmt := format('INSERT INTO fieldsets.fieldsets(id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store) VALUES (%s, %L, %L, %s, %L, %s, %L, %s, %L, %L::FIELD_TYPE, %L::STORE_TYPE);', fieldset_id, fieldset_token, fieldset_label, fieldset_parent_record.id, fieldset_parent_token, set_parent_id, data_record.token, 2, 'fieldset', 'fieldset', 'fieldset');
				EXECUTE insert_stmt;
				COMMIT;
			END IF;

			FOR field_name IN
				SELECT jsonb_object_keys
				FROM jsonb_object_keys(json_record.value)
				WHERE jsonb_object_keys NOT IN ('label', 'token', 'parent')
			LOOP
				SELECT 	id,
						token,
						label,
						parent,
						parent_token,
						set_id,
						set_token,
						field_id,
						field_token,
						type,
						store
				INTO fieldset_record
				FROM fieldsets.fieldsets
				WHERE token = field_name AND parent_token = field_name;

				field_value := json_record.value->>field_name;

				--RAISE NOTICE 'RAW VALUE: (FIELD %: %)', field_name, field_value;
				escaped_field_value := format($ESCAPED_JSON$"%s"$ESCAPED_JSON$,field_value::TEXT);
				BEGIN
					SELECT jsonb_typeof(field_value::JSONB) INTO json_field_data_type;
				EXCEPTION WHEN invalid_text_representation OR numeric_value_out_of_range THEN
					SELECT jsonb_typeof(escaped_field_value::JSONB) INTO json_field_data_type;
				END;

				-- If of type fieldset, match the token to the id and update variables.
				IF fieldset_record.type::TEXT = 'fieldset' AND fieldset_record.store::TEXT <> 'fieldset' AND json_field_data_type = 'string' THEN
					SELECT id INTO field_value FROM fieldsets.tokens WHERE token = field_name;
					escaped_field_value := format($ESCAPED_JSON$"%s"$ESCAPED_JSON$,field_value::TEXT);
					BEGIN
						SELECT jsonb_typeof(field_value::JSONB) INTO json_field_data_type;
					EXCEPTION WHEN invalid_text_representation OR numeric_value_out_of_range THEN
						SELECT jsonb_typeof(escaped_field_value::JSONB) INTO json_field_data_type;
					END;
				END IF;

				SELECT fieldsets.get_field_data_type(fieldset_record.type::TEXT) INTO field_data_type;

				--RAISE NOTICE 'IMPORT DATA: (FIELD %: %)', field_name, field_value;
				--RAISE NOTICE 'IMPORT DATA TYPES: JSON TYPE - %, SQL TYPE - %, FIELD TYPE - %, STORE TYPE - %)', json_field_data_type, field_data_type, fieldset_record.type::TEXT, fieldset_record.store::TEXT;
				IF ((field_value IS NOT NULL) AND (length(field_value::TEXT) > 0)) THEN

					-- Strip unwanted chars from any numbers
					IF ((field_data_type = 'BIGINT') OR (field_data_type = 'DECIMAL')) THEN
						SELECT replace(field_value::TEXT, ',', '') INTO field_value;
					END IF;

					CASE fieldset_record.store::TEXT
						WHEN 'filter' THEN
							insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, created, updated, %s) VALUES(%s, %s, %L, NOW(), %L::%s) ON CONFLICT ON CONSTRAINT %s_%s_id_pkey DO UPDATE SET %s = %L::%s, updated = NOW();', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, fieldset_created_timestamp, field_value, field_data_type, data_record.token, fieldset_record.store::TEXT, field_name, field_value, field_data_type);
						WHEN 'lookup' THEN
							IF json_field_data_type = 'array' THEN
								json_array_count := 0;
								FOR json_field_value IN
									SELECT * FROM jsonb_array_elements(jsonb_strip_nulls(field_value::JSONB))
								LOOP
									SELECT jsonb_typeof(json_field_value::JSONB) INTO json_field_data_type;
									IF json_field_data_type <> 'null' THEN
										IF json_field_data_type = 'object' THEN
											SELECT array_to_string(array_agg(key),',') AS keys, concat($$'$$, array_to_string(array_agg(value),$$','$$), $$'$$) AS values INTO json_fields FROM jsonb_each_text(jsonb_strip_nulls(json_field_value::JSONB));
											SELECT (fieldsets.create_field_value(json_fields.values, fieldset_record.type::TEXT)).* INTO typed_field_value;
										ELSE
											SELECT trim(BOTH '"' FROM json_field_value::TEXT) INTO trimmed_field_value;
											SELECT (fieldsets.create_field_value(trimmed_field_value, fieldset_record.type::TEXT)).* INTO typed_field_value;
										END IF;
										insert_stmt := format(E'%s\nINSERT INTO fieldsets.%s_%s(id, parent, field_id, type, value) VALUES (%s, %s, %s, %L, %L::FIELD_VALUE) ON CONFLICT ON CONSTRAINT %s_%s_pkey DO UPDATE SET value = %L::FIELD_VALUE;', insert_stmt, data_record.token, fieldset_record.store::TEXT, fieldset_id, fieldset_parent_record.id, fieldset_record.field_id, fieldset_record.type, typed_field_value, data_record.token, fieldset_record.store::TEXT, typed_field_value);
									END IF;
								END LOOP;
							ELSIF json_field_data_type = 'string' THEN
								SELECT trim(BOTH '"' FROM field_value::TEXT) INTO trimmed_field_value;
								SELECT (fieldsets.create_field_value(trimmed_field_value, fieldset_record.type::TEXT)).* INTO typed_field_value;
								insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, field_id, type, value) VALUES(%s, %s, %s, %L::FIELD_TYPE, %L::FIELD_VALUE) ON CONFLICT ON CONSTRAINT %s_%s_pkey DO UPDATE SET value = %L::FIELD_VALUE;', data_record.token, fieldset_record.store::TEXT, fieldset_id::TEXT, fieldset_parent_record.id::TEXT, fieldset_record.field_id::TEXT, fieldset_record.type::TEXT, typed_field_value, data_record.token, fieldset_record.store::TEXT, typed_field_value);
							ELSE
								SELECT (fieldsets.create_field_value(field_value, fieldset_record.type::TEXT)).* INTO typed_field_value;
								insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, field_id, type, value) VALUES(%s, %s, %s, %L::FIELD_TYPE, %L::FIELD_VALUE) ON CONFLICT ON CONSTRAINT %s_%s_pkey DO UPDATE SET value = %L::FIELD_VALUE;', data_record.token, fieldset_record.store::TEXT, fieldset_id::TEXT, fieldset_parent_record.id::TEXT, fieldset_record.field_id::TEXT, fieldset_record.type::TEXT, typed_field_value, data_record.token, fieldset_record.store::TEXT, typed_field_value);
							END IF;
						WHEN 'record' THEN
							IF json_field_data_type = 'array' THEN
								json_array_count := 0;
								insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, %s) VALUES',data_record.token, fieldset_record.store::TEXT, field_name);
								FOR json_field_value IN
									SELECT * FROM jsonb_array_elements(jsonb_strip_nulls(field_value::JSONB))
								LOOP
									IF json_field_value IS NOT NULL THEN
										--RAISE NOTICE 'RECORD ARRAY VALUE: %', json_field_value;
										insert_stmt := format(E'%s\n(%s,%s, %L::%s),', insert_stmt, fieldset_id, fieldset_parent_record.id, json_field_value, field_data_type);
										json_array_count := json_array_count + 1;
									END IF;
								END LOOP;
								IF json_array_count > 0 THEN
									insert_stmt := trim(TRAILING ',' FROM insert_stmt);
									insert_stmt := format('%s;', insert_stmt);
								ELSE
									insert_stmt := '';
								END IF;
							ELSE
								insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, created, %s) VALUES(%s, %s, %L, %L::%s);', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, fieldset_created_timestamp, field_value, field_data_type);
							END IF;
						WHEN 'document' THEN
							json_path := format('{%s}',field_name);
							SELECT document INTO json_data FROM fieldsets.documents WHERE id = fieldset_record.id AND parent = fieldset_record.parent;
							IF json_field_data_type = 'string' THEN
								json_data := jsonb_set(COALESCE(json_data, '{}'::JSONB), json_path, escaped_field_value::JSONB);
							ELSE
								json_data := jsonb_set(COALESCE(json_data, '{}'::JSONB), json_path, field_value::JSONB);
							END IF;
							insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,created,updated,document) VALUES(%s, %s, %L, NOW(), $ESCAPED_JSON$%s$ESCAPED_JSON$::JSONB) ON CONFLICT ON CONSTRAINT %s_%s_id_pkey DO UPDATE SET document = (fieldsets.%s_%s.document::JSONB || $ESCAPED_JSON$%s$ESCAPED_JSON$::JSONB), updated = NOW();', data_record.token, fieldset_record.store::TEXT, fieldset_id, fieldset_parent_record.id, fieldset_created_timestamp, json_data, data_record.token, fieldset_record.store::TEXT, data_record.token, fieldset_record.store::TEXT, json_data);
						WHEN 'stream' THEN
							stream_data := format('%s : %s', field_name, field_value);
							insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,data) VALUES(%s,%s, %L);', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, stream_data);
						ELSE
							insert_stmt := '';
					END CASE;

					IF insert_stmt <> '' THEN
						stores_insert_stmt := format(E'%s\n%s', stores_insert_stmt, insert_stmt);
					END IF;
				END IF;
			END LOOP;
		END LOOP;
	END LOOP;
	IF stores_insert_stmt <> '' THEN
		EXECUTE stores_insert_stmt;
	END IF;
	UPDATE pipeline.imports SET imported = TRUE WHERE type = 'data' AND imported = FALSE;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_data() IS
'/**
 * import_json_data: takes a fieldset json data found in the pipeine.imports table and insert it into corresponding tables.
 **/';
