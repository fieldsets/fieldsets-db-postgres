/**
 * parse_json_schema: take a fieldset json schema and convert it to a row format.
 * @param TEXT: json_string
 **/
CREATE OR REPLACE FUNCTION fieldsets.parse_json_schema(json_string TEXT)
RETURNS TABLE (
    set_token TEXT,
    set_label TEXT,
    set_parent TEXT,
    set_meta_data JSONB,
    field_token TEXT,
    field_label TEXT,
    field_type TEXT,
    field_store TEXT,
    field_parent TEXT,
    field_default_value JSONB,
    field_values JSONB,
    field_meta_data JSONB
)
AS $function$
    SELECT
        token AS set_token,
        label AS set_label,
        parent AS set_parent,
        meta_data AS set_meta_data,
        field ->> 'token' AS field_token,
        field ->> 'label' AS field_label,
        field ->> 'type' AS field_type,
        CASE
            WHEN field ? 'store' THEN
                field ->> 'store'
            ELSE
                'filter'
        END AS field_store,
        CASE
            WHEN field ? 'parent' THEN
                field ->> 'parent'
            ELSE
                field ->> 'type'
        END AS field_parent,
        CASE
            WHEN field ? 'value' THEN
                field -> 'value'
            ELSE
                NULL
        END AS field_default_value,
        CASE
            WHEN field ? 'values' THEN
                field -> 'values'
            ELSE
                '[]'::JSONB
        END AS field_values,
        CASE
            WHEN field ? 'meta_data' THEN
                field -> 'meta_data'
            ELSE
                '{}'::JSONB
        END AS field_meta_data
    FROM (
        SELECT
            token,
            label,
            parent,
            jsonb_array_elements(fields) AS field,
            meta_data
        FROM (
            SELECT
                value ->> 'token' AS token,
                value ->> 'label' AS label,
                CASE
                    WHEN value ? 'parent' THEN
                        value ->> 'parent'
                    ELSE
                        value ->> 'token'
                END AS parent,
                value -> 'fields' AS fields,
                CASE
                    WHEN value ? 'meta_data' THEN
                        value -> 'meta_data'
                    ELSE
                        '{}'::JSONB
                END AS meta_data
            FROM jsonb_array_elements(json_string::JSONB)
        ) fs_import_json
    ) fs_import_fields;
$function$ LANGUAGE sql;

COMMENT ON FUNCTION fieldsets.parse_json_schema(TEXT) IS
'/**
 * parse_json_schema: take a fieldset json schema and convert it to a row format.
 * @param TEXT: json_string
 **/';
