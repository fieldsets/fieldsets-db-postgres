DO $$ DECLARE
    type_exists BOOLEAN;
BEGIN
	SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_type WHERE typname='FIELD_VALUE') INTO type_exists;
    IF NOT type_exists THEN
        EXECUTE format('CREATE TYPE FIELD_VALUE AS (
                %I      BIGINT,
                %I		TEXT,
                %I		BIGINT,
                %I		DECIMAL,
                %I		JSONB,
                %I 		TEXT[],
                %I		DECIMAL[],
                %I		JSONB[],
                %I 		BOOLEAN,
                %I 		DATE,
                %I		TIMESTAMP,
                %I      TSVECTOR,
                %I      UUID,
                %I		JSONB,
                %I      TEXT,
                %I		JSONB,
                %I      JSONB
            );',
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
            'enum',
            'custom',
            'any'
        );
    END IF;
END $$;
