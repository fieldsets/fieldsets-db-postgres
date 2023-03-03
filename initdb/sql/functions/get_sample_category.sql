/**
 * get_sample_category: Get the sample category of a given sample
 * @param TEXT: samplename
 * @returns TEXT
 **/
CREATE OR REPLACE function fieldsets.get_sample_category(samplename TEXT)
RETURNS TEXT
AS $function$ DECLARE
	samp_id INT;
    samp_cat TEXT;
BEGIN
	SELECT sample_id FROM fieldsets.sample WHERE sample_name = samplename INTO samp_id;
    SELECT sample_data_value FROM fieldsets.sample_data_string_value WHERE sample_data_id = 7 AND sample_id = samp_id INTO samp_cat;
   
   	RETURN samp_cat;		
END $function$ 
LANGUAGE plpgsql;     

COMMENT ON FUNCTION fieldsets.get_sample_category (TEXT) IS 
'/**
 * get_sample_category: Get the sample category of a given sample
 * @param TEXT: samplename
 * @returns TEXT
 **/';