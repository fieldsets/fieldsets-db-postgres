DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='field_type') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format(
            'CREATE TYPE field_type AS ENUM (%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L);', 
            'fieldset',
            'string', 
            'number', 
            'decimal', 
            'object', 
            'list', 
            'array', 
            'bool', 
            'date', 
            'ts', 
            'function', 
            'custom'
        );
    END IF;
END $$;

