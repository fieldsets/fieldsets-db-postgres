DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='store_type') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format(
            'CREATE TYPE store_type AS ENUM (%L, %L, %L, %L, %L, %L, %L, %L, %L);',
            'filter',
            'mapping',
            'record',
            'document',
            'message',
            'sequence',
            'file',
            'program',
            'custom'
        );
    END IF;
END $$;
