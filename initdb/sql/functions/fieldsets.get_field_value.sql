/**
 * get_field_value: Input a FIELD_VALUE data type and the corresponding FIELD_TYPE and return the value.
 * @param TEXT: json_string
 **/
CREATE OR REPLACE FUNCTION fieldsets.get_field_value(field_value anyelement, field_type TEXT)
RETURNS RECORD
AS $function$
    DECLARE
        param_type regtype := pg_typeof(field_value);
        return_type regtype;
        data_value_string TEXT;
        query_sql TEXT;
        query_result RECORD;
        return_result RECORD;
    BEGIN
        IF param_type::TEXT = 'field_value' THEN
            data_value_string := CAST(field_value AS TEXT);
            query_sql := format('SELECT (val).%s AS value FROM (SELECT %L::FIELD_VALUE AS val) fv', field_type, data_value_string);
            EXECUTE query_sql INTO query_result;
            return_type := pg_typeof(query_result.value);
            return_result := ROW(query_result.value);
        END IF;
        RETURN return_result;
    END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.get_field_value(anyelement, TEXT) IS
'/**
 * get_field_value: Input a FIELD_VALUE data type and the corresponding FIELD_TYPE and return the value.
 * @param FIELD_VALUE: Custom FIELD_VALUE composite data type
 * @param FIELD_TYPE: Custom FIELD_TYPE
 **/';
