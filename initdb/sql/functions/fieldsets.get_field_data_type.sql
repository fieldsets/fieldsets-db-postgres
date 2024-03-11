/**
 * get_field_data_type: Input a data value and the corresponding FIELD_TYPE and return the SQL representation of its FIELD_VALUE.
 * @param TEXT: field_type
 * @return ANY: BIGINT,TEXT,BIGINT,DECIMAL,JSONB,TEXT[],DECIMAL[],JSONB[],BOOLEAN,DATE,TIMESTAMP,TSVECTOR,UUID,JSONB,TEXT,JSONB,JSONB
 **/
CREATE OR REPLACE FUNCTION fieldsets.get_field_data_type(field_type TEXT)
RETURNS TEXT
AS $function$
    BEGIN
        CASE field_type
            WHEN 'fieldset' THEN
                RETURN 'BIGINT';
            WHEN 'string' THEN
                RETURN 'TEXT';
            WHEN 'number' THEN
                RETURN 'BIGINT';
            WHEN 'decimal' THEN
                RETURN 'DECIMAL';
            WHEN 'object' THEN
                RETURN 'JSONB';
            WHEN 'list' THEN
                RETURN 'TEXT[]';
            WHEN 'array' THEN
                RETURN 'DECIMAL[]';
            WHEN 'vector' THEN
                RETURN 'JSONB[]';
            WHEN 'bool' THEN
                RETURN 'BOOLEAN';
            WHEN 'date' THEN
                RETURN 'DATE';
            WHEN 'ts' THEN
                RETURN 'TIMESTAMP';
            WHEN 'search' THEN
                RETURN 'TSVECTOR';
            WHEN 'uuid' THEN
                RETURN 'UUID';
            WHEN 'function' THEN
                RETURN 'JSONB';
            WHEN 'enum' THEN
                RETURN 'TEXT';
            WHEN 'custom' THEN
                RETURN 'JSONB';
            WHEN 'any' THEN
                RETURN 'JSONB';
            ELSE
                RETURN 'TEXT';
        END CASE;
    END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.get_field_data_type(TEXT) IS
'/**
 * get_field_data_type: Input a data value and the corresponding FIELD_TYPE and return the SQL representation of its FIELD_VALUE.
 * @param TEXT: field_type
 * @return ANY: BIGINT,TEXT,BIGINT,DECIMAL,JSONB,TEXT[],DECIMAL[],JSONB[],BOOLEAN,DATE,TIMESTAMP,TSVECTOR,UUID,JSONB,TEXT,JSONB,JSONB
 **/';
