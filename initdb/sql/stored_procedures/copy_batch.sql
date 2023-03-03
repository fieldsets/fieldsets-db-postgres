/**
 * copy_batch
 * @description: Copy all reference sample information within a batch name VBDB while respecting table constraints.
 * @usage: call copy_batch('BATCH_AUTO031')
 */
CREATE OR REPLACE PROCEDURE copy_batch(batch_name TEXT, source_schema TEXT DEFAULT 'fieldsets')
AS
$procedure$
DECLARE
	batch RECORD;
    sample RECORD;
	insert_sql TEXT;
	analysis_ids TEXT;
BEGIN
	-- Batch Data
	EXECUTE format('SELECT batch_id, flowcell_id, batch_name FROM %I.batch WHERE batch_name = %L', source_schema, batch_name) INTO batch;
	RAISE NOTICE 'Copying Batch: {batch_id: %, flowcell_id: %, batch_name: %}', batch.batch_id, batch.flowcell_id, batch.batch_name;

	-- Fetch Sample Info
	FOR sample IN
		EXECUTE format('SELECT * FROM %I.sample WHERE batch_id = %s', source_schema, batch.batch_id)
	LOOP
		insert_sql := format('CALL copy_sample_data(%L,%L);', sample.sample_name, source_schema);
		EXECUTE insert_sql;
	END LOOP;
END;
$procedure$
LANGUAGE plpgsql;