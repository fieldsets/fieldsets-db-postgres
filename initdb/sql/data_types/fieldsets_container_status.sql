DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='fieldsets_container_status') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format('CREATE TYPE pipeline.FIELDSETS_CONTAINER_STATUS AS ENUM (%L,%L,%L,%L,%L,%L,%L,%L,%L,%L,%L,%L);', 'pending', 'initializing', 'ready', 'provisioning', 'building', 'executing', 'error', 'waiting', 'complete', 'dedicated', 'stopped', 'terminated');
    END IF;
END $$;
