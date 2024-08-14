/**
 * create_field_value: Input a data value and the corresponding FIELD_TYPE and return the SQL representation of its FIELD_VALUE.
 * @param anyelement: field_value
 * @param TEXT: field_type
 * @return FIELD_VALUE: ROW(BIGINT,TEXT,BIGINT,DECIMAL,JSONB,TEXT[],DECIMAL[],JSONB[],BOOLEAN,DATE,TIMESTAMP,TSVECTOR,UUID,JSONB,TEXT,JSONB,JSONB)
 **/
CREATE OR REPLACE FUNCTION fieldsets.create_field_value(field_value anyelement, field_type TEXT)
RETURNS FIELD_VALUE
AS $function$
    DECLARE
        return_result FIELD_VALUE;
    BEGIN
        CASE field_type
            WHEN 'fieldset' THEN
                return_result := ROW(field_value::BIGINT,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'string' THEN
                return_result := ROW(NULL,field_value::TEXT,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'number' THEN
                return_result := ROW(NULL,NULL,field_value::BIGINT,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'decimal' THEN
                return_result := ROW(NULL,NULL,NULL,field_value::DECIMAL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'object' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,field_value::JSONB,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'list' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,field_value::TEXT[],NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'array' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,field_value::DECIMAL[],NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'vector' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::JSONB[],NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'bool' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::BOOLEAN,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'date' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::DATE,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'ts' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::TIMESTAMP,NULL,NULL,NULL,NULL,NULL,NULL);
            WHEN 'search' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::TSVECTOR,NULL,NULL,NULL,NULL,NULL);
            WHEN 'uuid' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::UUID,NULL,NULL,NULL,NULL);
            WHEN 'function' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::JSONB,NULL,NULL,NULL);
            WHEN 'enum' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::TEXT,NULL,NULL);
            WHEN 'custom' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::JSONB,NULL);
            WHEN 'any' THEN
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,field_value::JSONB);
            ELSE
                return_result := ROW(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
        END CASE;
        RETURN return_result;
    END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.create_field_value(anyelement, TEXT) IS
'/**
 * create_field_value: Input a data value and the corresponding FIELD_TYPE and return the SQL representation of its FIELD_VALUE.
 * @param anyelement: field_value
 * @param TEXT: field_type
 * @return FIELD_VALUE: ROW(BIGINT,TEXT,BIGINT,DECIMAL,JSONB,TEXT[],DECIMAL[],JSONB[],BOOLEAN,DATE,TIMESTAMP,TSVECTOR,UUID,JSONB,TEXT,JSONB,JSONB)
 **/';
