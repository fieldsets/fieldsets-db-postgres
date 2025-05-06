/**
 * trigger_generate_enums: triggered after insert into fieldsets table. Calculate enumerated values from fieldsets.
 * @depends TRIGGER: trigger_31_generate_enums
 **/
CREATE OR REPLACE FUNCTION fieldsets.trigger_generate_enums() RETURNS trigger AS $function$
  DECLARE
    insert_stmt TEXT := 'INSERT INTO fieldsets.enums(id,token,field_id,field_token) VALUES';
    sql_stmt TEXT := '';
    key_name TEXT;
    parent_record RECORD;
    partition_status RECORD;
    partition_table_name TEXT;
  BEGIN
    SELECT id, token, parent, parent_token, field_id, field_token
    INTO parent_record
    FROM fieldsets.fieldsets
    WHERE
      type = 'enum'::FIELD_TYPE AND
      parent_token = NEW.parent_token;

    IF parent_record IS NOT NULL THEN
      partition_table_name := format('__%s_enum', parent_record.field_token);
      SELECT to_regclass(format('fieldsets.%I',partition_table_name)) INTO partition_status;
      IF partition_status IS NULL THEN
        sql_stmt := format('CREATE TABLE IF NOT EXISTS fieldsets.%I PARTITION OF fieldsets.enums FOR VALUES IN (%s) TABLESPACE fieldsets;', partition_table_name, parent_record.field_id::TEXT);
        EXECUTE sql_stmt;

        key_name := format('%s_enum_id_pkey', parent_record.field_token);
        sql_stmt := format('ALTER TABLE fieldsets.%I ADD CONSTRAINT %I PRIMARY KEY (id);', partition_table_name, key_name);
        EXECUTE sql_stmt;

        key_name := format('%s_enum_idx', parent_record.field_token);
        sql_stmt := format('CREATE INDEX IF NOT EXISTS %I ON fieldsets.%I USING HASH (token);', key_name, partition_table_name);
        EXECUTE sql_stmt;

        key_name := format('%s_enum_fieldset_fkey', parent_record.field_token);
        sql_stmt := format('ALTER TABLE fieldsets.%I ADD CONSTRAINT %I FOREIGN KEY (id) REFERENCES fieldsets.tokens(id) DEFERRABLE;', partition_table_name, key_name);
        EXECUTE sql_stmt;

        key_name := format('%s_enum_field_fkey', parent_record.field_token);
        sql_stmt := format('ALTER TABLE fieldsets.%I ADD CONSTRAINT %I FOREIGN KEY (field_id) REFERENCES fieldsets.fields(id) DEFERRABLE;', partition_table_name, key_name);
        EXECUTE sql_stmt;
      END IF;

      sql_stmt := format('(%s,%L,%s,%L)', NEW.id, NEW.token, parent_record.field_id, parent_record.field_token);
      insert_stmt := format(E'%s\n%s,', insert_stmt, sql_stmt);
      insert_stmt := trim(TRAILING ',' FROM insert_stmt);
      EXECUTE insert_stmt;
    END IF;
    RETURN NEW;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.trigger_generate_enums() IS
'/**
 * trigger_generate_enums: triggered after insert into fieldsets table. Calculate enumerated values from fieldsets.
 * @depends TRIGGER: trigger_31_generate_enums
 **/';