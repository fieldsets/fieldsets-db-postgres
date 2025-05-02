DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='FIELDSET_RECORD') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format('CREATE TYPE FIELDSET_RECORD AS (
                %I      BIGINT,
                %I		TEXT,
                %I		TEXT,
                %I		BIGINT,
                %I		TEXT,
                %I 		BIGINT,
                %I		TEXT,
                %I		BIGINT,
                %I 		TEXT,
                %I 		FIELD_TYPE,
                %I		STORE_TYPE
            );',
            'id',
            'token',
            'label',
            'parent',
            'parent_token',
            'set_id',
            'set_token',
            'field_id',
            'field_token',
            'type',
            'store'
        );
    END IF;
END $$;