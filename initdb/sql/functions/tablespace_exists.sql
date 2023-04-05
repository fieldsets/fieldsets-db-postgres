/**
 * tablespace_exists: Check if a tablespace exists.
 * @param TEXT: tablespace_name
 * @returns BOOLEAN
 **/
CREATE OR REPLACE FUNCTION public.tablespace_exists(tablespace_name TEXT) RETURNS BOOLEAN 
AS $function$
DECLARE
    tablespace_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM pg_catalog.pg_tablespace WHERE spcname=tablespace_name) INTO tablespace_exists;
    IF tablespace_exists THEN
     RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$function$
STRICT
LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION public.isnumeric (TEXT) IS 
'/**
 * isnumeric: Check if a text field is numeric.
 * @param TEXT: val
 * @returns BOOLEAN
 **/';