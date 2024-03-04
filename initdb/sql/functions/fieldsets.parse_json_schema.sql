/**
 * parse_json_schema: take a fieldset json schema and convert it to a row format.
 * @param TEXT: json_string
 **/
CREATE OR REPLACE FUNCTION fieldsets.parse_json_schema(json_string TEXT)
RETURNS TABLE (
    set_token TEXT,
    set_label TEXT,
    set_parent TEXT,
    set_metadata JSONB,
    field_token TEXT,
    field_label TEXT,
    field_type TEXT,
    field_store TEXT,
    field_parent TEXT,
    field_default_value JSONB,
    field_values JSONB,
    field_metadata JSONB
)
AS $function$
    SELECT
        token AS set_token,
        label AS set_label,
        parent AS set_parent,
        metadata AS set_metadata,
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
                NULL
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
            WHEN field ? 'metadata' THEN
                field -> 'metadata'
            ELSE
                '{}'::JSONB
        END AS field_metadata
    FROM (
        SELECT
            token,
            label,
            parent,
            jsonb_array_elements(fields) AS field,
            metadata
        FROM (
            SELECT
                value ->> 'token' AS token,
                value ->> 'label' AS label,
                CASE
                    WHEN value ? 'parent' THEN
                        value ->> 'parent'
                    ELSE
                        'fieldset'
                END AS parent,
                value -> 'fields' AS fields,
                CASE
                    WHEN value ? 'metadata' THEN
                        value -> 'metadata'
                    ELSE
                        '{}'::JSONB
                END AS metadata
            FROM jsonb_array_elements(json_string::JSONB)
        ) fs_import_json
    ) fs_import_fields;
$function$ LANGUAGE sql;

COMMENT ON FUNCTION fieldsets.parse_json_schema(TEXT) IS
'/**
 * parse_json_schema: take a fieldset json schema and convert it to a row format.
 * @param TEXT: json_string
 **/';
