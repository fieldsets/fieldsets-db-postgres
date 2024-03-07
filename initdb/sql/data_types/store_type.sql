DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='STORE_TYPE') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format(
            'CREATE TYPE STORE_TYPE AS ENUM (%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L);',
            'filter',
            'lookup',
            'record',
            'document',
            'message',
            'sequence',
            'view',
            'file',
            'program',
            'custom',
            'none',
            'any'
        );
    END IF;
END $$;
