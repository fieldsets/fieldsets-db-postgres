/**
 * copy_sample
 * @description: Copy all reference information related to a sample name from VBDB respecting table constraints.
 * @usage: call copy_sample('2RAD_1052164')
 */
CREATE OR REPLACE PROCEDURE copy_sample(sample_name TEXT, source_schema TEXT DEFAULT 'fieldsets')
AS
$procedure$
DECLARE
	sample RECORD;
	insert_sql TEXT;
	analysis_ids TEXT;
BEGIN
    -- Value Type lookup.
	insert_sql := format('INSERT INTO value_type SELECT * FROM %I.value_type ON CONFLICT DO NOTHING', source_schema);
	EXECUTE insert_sql;

    -- Pipeline
    insert_sql := format('INSERT INTO analysis_pipeline SELECT * FROM %I.analysis_pipeline ON CONFLICT DO NOTHING', source_schema);
    EXECUTE insert_sql;

    insert_sql := format('INSERT INTO analysis_pipeline_version SELECT * FROM %I.analysis_pipeline_version ON CONFLICT DO NOTHING', source_schema);
    EXECUTE insert_sql;

    -- Definitions
    insert_sql := format('INSERT INTO flowcell_data_definition SELECT * FROM %I.flowcell_data_definition ON CONFLICT DO NOTHING',source_schema);
    EXECUTE insert_sql;
    insert_sql := format('INSERT INTO batch_data_definition SELECT * FROM %I.batch_data_definition ON CONFLICT DO NOTHING',source_schema);
    EXECUTE insert_sql;
    insert_sql := format('INSERT INTO sample_data_definition SELECT * FROM %I.sample_data_definition ON CONFLICT DO NOTHING',source_schema);
    EXECUTE insert_sql;
    insert_sql := format('INSERT INTO analysis_data_definition SELECT * FROM %I.analysis_data_definition ON CONFLICT DO NOTHING',source_schema);
    EXECUTE insert_sql;

    -- Fetch Sample Info
    FOR sample IN
    	EXECUTE format('SELECT sample_id, sample_name, plate_position,batch_id, flowcell_id, sample_name_lims FROM %I.sample WHERE sample_name = %L', source_schema, sample_name)
    LOOP
        RAISE NOTICE 'Copying Sample Record: %, %, %, %, %, %', sample.sample_id, sample.sample_name, sample.plate_position, sample.batch_id, sample.flowcell_id, sample.sample_name_lims;
        
        -- Execution Data
        insert_sql := format('INSERT INTO execution SELECT * FROM %I.execution WHERE execution_id IN (SELECT execution_id FROM %I.analysis WHERE sample_id = %s) ON CONFLICT DO NOTHING', source_schema, source_schema, sample.sample_id);
        EXECUTE insert_sql;

        -- Flowcell Data
        insert_sql := format('INSERT INTO flowcell SELECT * FROM %I.flowcell WHERE flowcell_id = %s ON CONFLICT DO NOTHING', source_schema, sample.flowcell_id);
        EXECUTE insert_sql;

        -- Batch Data
        insert_sql := format('INSERT INTO batch SELECT * FROM %I.batch WHERE batch_id = %s ON CONFLICT DO NOTHING',source_schema, sample.batch_id);
        EXECUTE insert_sql;

        -- Sample Data
        insert_sql := format('INSERT INTO sample SELECT * FROM %I.sample WHERE sample_id = %s ON CONFLICT DO NOTHING', source_schema, sample.sample_id);
        EXECUTE insert_sql;

        -- Analysis Data
        insert_sql := format('INSERT INTO analysis SELECT * FROM %I.analysis WHERE sample_id = %s ON CONFLICT DO NOTHING', source_schema, sample.sample_id);
        EXECUTE insert_sql;

        EXECUTE format('SELECT string_agg(analysis_id::TEXT, %L) FROM %I.analysis WHERE sample_id = %s', ',', source_schema, sample.sample_id) INTO analysis_ids;

    END LOOP;
END;
$procedure$
LANGUAGE plpgsql;