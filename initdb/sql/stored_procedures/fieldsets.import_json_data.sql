/**
 * import_json_data: takes a fieldset json data found in the pipeine.imports table and insert it into corresponding tables.
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_data() AS $procedure$
DECLARE
	json_record RECORD;
	json_path TEXT;
	json_data JSONB;
	data_record RECORD;
	insert_stmt TEXT := '';
	stores_insert_stmt TEXT := '';
	field_record RECORD;
	field_name TEXT;
	field_value TEXT;
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
	stream_data TEXT;
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
				WHERE token = field_name AND parent_token = field_name AND set_token = data_record.token;

				field_value := json_record.value->>field_name;
				SELECT fieldsets.get_field_data_type(fieldset_record.type::TEXT) INTO field_data_type;

				CASE fieldset_record.store::TEXT
					WHEN 'filter' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, updated, %s) VALUES(%s, %s, NOW(), %L::%s) ON CONFLICT ON CONSTRAINT %s_%s_id_pkey DO UPDATE SET %s = %L::%s, updated = NOW();', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, field_value, field_data_type, data_record.token, fieldset_record.store::TEXT, field_name, field_value, field_data_type);
					WHEN 'lookup' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, %s) VALUES(%s, %s, %L::%s) ON CONFLICT ON CONSTRAINT %s_%s_id_pkey DO UPDATE SET %s = %L::%s;', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, field_value, field_data_type, data_record.token, fieldset_record.store::TEXT, field_name, field_value, field_data_type);
					WHEN 'record' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id, parent, %s) VALUES(%s,%s, %L::%s);', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, field_value);
					WHEN 'document' THEN
						json_path := format('{%s}',field_name);
						SELECT json_set(COALESCE(document, '{}'::JSONB), json_path, field_value) AS document INTO json_data FROM fieldsets.documents WHERE id = fieldset_record.id AND parent = fieldset_record.parent;
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,updated,document) VALUES(%s, %s, NOW(), %L::%s) ON CONFLICT ON CONSTRAINT %s_%s_id_pkey DO UPDATE SET document = %L::%s, updated = NOW();', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, json_data::TEXT, field_data_type, data_record.token, fieldset_record.store::TEXT, json_data::TEXT, field_data_type);
					WHEN 'stream' THEN
						stream_data := format('%s : %s', field_name, field_value);
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,data) VALUES(%s,%s, %L);', data_record.token, fieldset_record.store::TEXT, field_name, fieldset_id, fieldset_parent_record.id, stream_data);
					ELSE
						insert_stmt := '';
				END CASE;

				IF insert_stmt <> '' THEN
					stores_insert_stmt := format(E'%s\n%s', stores_insert_stmt, insert_stmt);
				END IF;
			END LOOP;
		END LOOP;
	END LOOP;
	EXECUTE stores_insert_stmt;
	UPDATE pipeline.imports SET imported = TRUE WHERE type = 'data' AND imported = FALSE;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_data() IS
'/**
 * import_json_data: takes a fieldset json data found in the pipeine.imports table and insert it into corresponding tables.
 **/';
