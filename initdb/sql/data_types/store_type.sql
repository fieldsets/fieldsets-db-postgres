DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='STORE_TYPE') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format(
            'CREATE TYPE STORE_TYPE AS ENUM (%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L);',
            'none',
            'fieldset',
            'filter',
            'lookup',
            'record',
            'document',
            'stream',
            'sequence',
            'view',
            'file',
            'program',
            'custom',
            'any'
        );
    END IF;
END $$;
