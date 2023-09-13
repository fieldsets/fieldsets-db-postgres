DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='EVENT_STATUS') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format(
            'CREATE TYPE EVENT_STATUS AS ENUM (%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L);',
            'pending',
            'preprocessing',
            'processing',
            'error',
            'failed',
            'passed',
            'finalizing',
            'reprocess',
            'waiting',
            'review',
            'endefined',
            'complete'
        );
    END IF;
END $$;
