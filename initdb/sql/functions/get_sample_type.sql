/**
 * get_sample_type: Get the sample type of a given sample
 * @param TEXT: samplename
 * @returns TEXT
 **/
CREATE OR REPLACE function fieldsets.get_sample_type(samplename TEXT)
RETURNS TEXT
AS $function$ DECLARE
	samp_id INT;
    samp_type TEXT;
BEGIN
	SELECT sample_id FROM fieldsets.sample WHERE sample_name = samplename INTO samp_id;
    SELECT sample_data_value FROM fieldsets.sample_data_string_value WHERE sample_data_id = 6 AND sample_id = samp_id INTO samp_type;
   
   	RETURN samp_type;		
END $function$ 
LANGUAGE plpgsql;     

COMMENT ON FUNCTION fieldsets.get_sample_type (TEXT) IS 
'/**
 * get_sample_type: Get the sample type of a given sample
 * @param TEXT: samplename
 * @returns TEXT
 **/';