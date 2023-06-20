DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='field_value') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format('CREATE TYPE field_value AS (
                %I      BIGINT,
                %I		TEXT,
                %I		BIGINT,
                %I		DECIMAL,
                %I		JSONB,
                %I 		TEXT[],
                %I		DECIMAL[],
                %I 		BOOLEAN,
                %I 		DATE,
                %I		TIMESTAMP,
                %I      TSVECTOR,
                %I      UUID,
                %I		JSONB,
                %I      JSONB
            );',
            'fieldset',
            'string',
            'number',
            'decimal',
            'object',
            'list',
            'vector',
            'bool',
            'date',
            'ts',
            'search',
            'uuid',
            'function',
            'custom'
        );
    END IF;
END $$;
