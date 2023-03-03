DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='fieldsets_event_status') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format('CREATE TYPE pipeline.FIELDSETS_EVENT_STATUS AS ENUM (%L,%L,%L,%L,%L,%L,%L,%L,%L,%L,%L,%L);', 'pending', 'preprocessing', 'processing', 'error', 'failed', 'passed', 'finalizing', 'reprocess', 'waiting', 'review', 'undefined', 'complete');
    END IF;
END $$;
