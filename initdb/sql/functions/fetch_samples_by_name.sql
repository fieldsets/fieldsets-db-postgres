/**
 * fetch_samples_by_name: Fetch execution information by name
 * @param TEXT: name_type - values('run','batch','sample')
 * @param TEXT: by_name - batch_name, sample_name, run_name
 * @returns TABLE
 **/
CREATE OR REPLACE function fieldsets.fetch_samples_by_name(name_type TEXT, by_name TEXT)
RETURNS TABLE( s3bucket TEXT, execution_id INT, analysis_id INT, flowcell_id INT, run_name TEXT, batch_id INT, batch_name TEXT, sample_id INT, sample_name TEXT, sample_name_lims TEXT, plate_position INT)
AS $function$ DECLARE
	query_sql TEXT;
	filter_sql TEXT;
	select_stmt TEXT;
BEGIN
	query_sql := 'SELECT DISTINCT 
		CONCAT(f.run_name, ''-'', b.batch_name, ''-'', s.sample_name, ''-'', s.plate_position, ''-'', a.execution_id) AS s3bucket,
		a.execution_id, 
		a.analysis_id, 
		f.flowcell_id,
		f.run_name::TEXT AS run_name, 
		b.batch_id,
		b.batch_name::TEXT AS batch_name, 
		s.sample_id, 
		s.sample_name::TEXT AS sample_name,
		s.sample_name_lims::TEXT AS sample_name_lims,
		s.plate_position
    FROM 
    	fieldsets.flowcell f,
		fieldsets.batch b,
        fieldsets.sample s,
        fieldsets.analysis a 
    WHERE s.sample_id = a.sample_id 
    	AND f.flowcell_id = s.flowcell_id 
        AND b.batch_id = s.batch_id 
        AND b.flowcell_id = f.flowcell_id %s';
    
	CASE name_type
   		WHEN 'run' THEN
   			filter_sql := format('AND f.run_name = %L;', by_name);
   		WHEN 'batch' THEN 
   			filter_sql := format('AND b.batch_name = %L;', by_name);
   		ELSE
   			filter_sql := format('AND s.sample_name = %L;', by_name);
   	END CASE;
   
   	RETURN QUERY 
		EXECUTE format(query_sql, filter_sql);
	RETURN;
		
END $function$ 
LANGUAGE plpgsql;     

COMMENT ON FUNCTION fieldsets.fetch_samples_by_name (TEXT, TEXT) IS 
'/**
 * fetch_samples_by_name: Fetch execution information by name
 * @param TEXT: name_type - values(''run'',''batch'',''sample'')
 * @param TEXT: by_name - batch_name, sample_name, run_name
 * @returns TABLE
 **/';