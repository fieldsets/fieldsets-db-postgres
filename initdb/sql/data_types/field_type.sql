DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='FIELD_TYPE') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format(
            'CREATE TYPE FIELD_TYPE AS ENUM (%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L);',
            'fieldset',
            'string',
            'number',
            'decimal',
            'object',
            'list',
            'array',
            'vector',
            'bool',
            'date',
            'ts',
            'search',
            'uuid',
            'function',
            'alias',
            'enum',
            'custom',
            'none',
            'any'
        );
    END IF;
END $$;
