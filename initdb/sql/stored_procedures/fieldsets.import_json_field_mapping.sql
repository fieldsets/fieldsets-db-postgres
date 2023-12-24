-- Active: 1692635254843@@0.0.0.0@5432@fieldsets
/**
 * import_json_field_mapping: take a table and map it to an associated fieldset field.
 * @param TEXT: json_file_path
 **/
CREATE OR REPLACE PROCEDURE fieldsets.import_json_field_mapping(json_file_path TEXT) AS $procedure$
    DECLARE
        field_token         TEXT;
        fieldset_table_name TEXT;
        source_table_name   TEXT;
        source_col_name     TEXT;
    BEGIN
        --COPY json_field_mapping FROM 

    END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.import_json_field_mapping(TEXT) IS
'/**
 * import_json_field_mapping: take a table and map it to an associated fieldset field.
 * @param TEXT: json_file_path
 **/';
