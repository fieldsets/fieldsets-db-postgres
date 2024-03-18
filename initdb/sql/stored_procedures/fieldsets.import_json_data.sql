/**
 * import_json_data: takes a fieldset json data found in the pipeine.imports table and insert it into corresponding tables.
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_data() AS $procedure$
DECLARE
	json_record RECORD;
	data_record RECORD;
	parent_record RECORD;
	fieldset_record RECORD;
	set_record RECORD;
	insert_stmt TEXT := '';
	insert_values TEXT := '';
	insert_fieldset_values TEXT := '';
	insert_fieldsets_sql TEXT := 'INSERT INTO fieldsets.fieldsets (id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store) VALUES';
	fieldset_values_sql TEXT;
	field_id BIGINT;
	field_token TEXT;
	field_name TEXT;
	field_value TEXT;
	field_data_type TEXT;
	set_id BIGINT;
	set_token TEXT;
	fieldset_id BIGINT;
	fieldset_token TEXT;
	fieldset_parent_id BIGINT;
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
		insert_values := '';
		insert_fieldset_values := '';
		fieldset_values_sql := '';

		FOR json_record IN
			SELECT
				value
			FROM jsonb_array_elements(data_record.data)
		LOOP
			set_token := json_record.value->>'parent';
			fieldset_token := json_record.value->>'token';
			fieldset_label := json_record.value->>'label';

			SELECT id, token INTO set_record FROM fieldsets.sets WHERE token = set_token;
			SELECT id, token INTO field_record FROM fieldsets.fields WHERE token = fieldset_token;
			SELECT id, token INTO parent_record FROM fieldsets.fieldsets WHERE token = set_token AND set_token = set_token AND store = 'fieldset'::STORE_TYPE;

			SELECT id INTO fieldset_id FROM fieldsets.fieldsets WHERE token = fieldset_token AND set_token = set_token AND store = 'fieldset'::STORE_TYPE;
			IF fieldset_id IS NULL THEN
				SELECT nextval('fieldsets.fieldset_id_seq') INTO fieldset_id;
				--INSERT INTO fieldsets.fieldsets(id, token, label, parent, parent_token, set_id, set_token, field_id, field_token, type, store) VALUES (fieldset_id, fieldset_token, fieldset_label, parent_record.id, set_token, set_record.id, set_token, 2, 'fieldset', 'fieldset'::FIELD_TYPE, 'fieldset'::STORE_TYPE);
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
				WHERE token = field_name AND parent_token = field_name AND set_token = set_token;

				field_value := json_record.value->>field_name;
				SELECT fieldsets.get_field_data_type(fieldset_record.type::TEXT) INTO field_data_type;

				CASE fieldset_record.store::TEXT
					WHEN 'filter' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,updated,%s) VALUES(%s,%s, NOW(), %L::%s) ON CONFLICT ON CONSTRAINT %_%_id_pkey DO UPDATE', set_token, fieldset_record.type::TEXT, field_name, fieldset_id, parent_record.id, field_value, field_data_type, set_token, fieldset_record.type::TEXT);
					WHEN 'lookup' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,%s) VALUES(%s,%s,%)';
					WHEN 'record' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,%s) VALUES(%s,%s,%)';
					WHEN 'document' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,%s) VALUES(%s,%s,%)';
					WHEN 'stream' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,%s) VALUES(%s,%s,%)';
					WHEN 'sequence' THEN
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,%s) VALUES(%s,%s,%)';
					ELSE
						insert_stmt := format('INSERT INTO fieldsets.%s_%s(id,parent,%s) VALUES(%s,%s,%)';
				END CASE;

				RAISE NOTICE '%', insert_stmt;
			END LOOP;
		END LOOP;
		--UPDATE pipeline.imports SET imported = TRUE WHERE token = data_record.token AND type = 'schema' AND source = data_record.source AND priority = data_record.priority;
	END LOOP;
END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_data() IS
'/**
 * import_json_data: takes a fieldset json data found in the pipeine.imports table and insert it into corresponding tables.
 **/';
