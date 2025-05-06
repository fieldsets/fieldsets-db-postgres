/**
 * in_array: Check if a value exists in a single dimension array.
 * @param ANYELEMENT: search_val (value to search for)
 * @param ANYARRAY: target_array (array to search in)
 * @returns BOOLEAN
 **/
CREATE OR REPLACE FUNCTION public.in_array(search_val ANYELEMENT, target_array ANYARRAY) RETURNS BOOLEAN
AS $function$
DECLARE
    val_position INTEGER;
    val_exists BOOLEAN := FALSE;
BEGIN
    IF target_array IS NULL THEN
        RETURN FALSE;
    END IF;

    val_position := array_position(target_array, search_val);

    IF val_position IS NOT NULL THEN
        val_exists := TRUE;
    END IF;

    RETURN val_exists;
END;
$function$
STRICT
LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION public.in_array (ANYELEMENT,ANYARRAY) IS
'/**
 * @param ANYELEMENT: search_val (value to search for)
 * @param ANYARRAY: target_array (array to search in)
 * @returns BOOLEAN
 **/';