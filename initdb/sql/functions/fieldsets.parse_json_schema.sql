-- Active: 1692635254843@@0.0.0.0@5432@fieldsets@fieldsets
/**
 * parse_json_schema: take a fieldset json schema and convert it to a row format.
 * @param TEXT: json_string
 **/
CREATE OR REPLACE FUNCTION fieldsets.parse_json_schema(json_string TEXT)
RETURNS TABLE (
    set_token TEXT,
    set_label TEXT,
    set_parent TEXT,
    set_default_store TEXT,
    field_token TEXT,
    field_label TEXT,
    field_type TEXT,
    field_store TEXT,
    field_parent TEXT,
    field_default_value JSON
)
AS $function$
    SELECT
        token AS set_token,
        label AS set_label,
        parent AS set_parent,
        store AS set_default_store,
        field ->> 'token' AS field_token,
        field ->> 'label' AS field_label,
        field ->> 'type' AS field_type,
        CASE
            WHEN field ? 'store' THEN
                field ->> 'store'
            ELSE
                store
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
        END AS field_default_value
    FROM (
        SELECT
            token,
            label,
            parent,
            store,
            jsonb_array_elements(fields) AS field
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
                CASE
                    WHEN value ? 'store' THEN
                        value ->> 'store'
                    ELSE
                        'filter'
                END AS store,
                value -> 'fields' AS fields
            FROM jsonb_array_elements(json_string::JSONB)
        ) fs_import_json
    ) fs_import_fields;
$function$ LANGUAGE sql;

COMMENT ON FUNCTION fieldsets.parse_json_schema(TEXT) IS
'/**
 * parse_json_schema: take a fieldset json schema and convert it to a row format.
 * @param TEXT: json_string
 **/';
