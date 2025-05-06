/**
 * is_numeric: Check if a text field is numeric.
 * @param TEXT: val
 * @returns BOOLEAN
 **/
CREATE OR REPLACE FUNCTION public.is_numeric(val TEXT) RETURNS BOOLEAN
AS $function$
DECLARE x NUMERIC;
BEGIN
    x = val::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$function$
STRICT
LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION public.is_numeric (TEXT) IS 
'/**
 * is_numeric: Check if a text field is numeric.
 * @param TEXT: val
 * @returns BOOLEAN
 **/';