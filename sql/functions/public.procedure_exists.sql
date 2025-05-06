/**
 * procedure_exists: Checks a schema for a procedure with the given name
 * @param TEXT: schema_name
 * @param TEXT: proc_name
 * @returns BOOLEAN
 **/
CREATE OR REPLACE FUNCTION public.procedure_exists (schema_name TEXT,proc_name TEXT) RETURNS BOOLEAN
AS $function$
DECLARE
    proc TEXT;
    proc_exists BOOLEAN := FALSE;
BEGIN
    proc := format('%I.%I', schema_name, proc_name);
    SELECT to_regproc(proc) IS NOT NULL INTO proc_exists;
    RETURN proc_exists;
END;
$function$
STRICT
LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION public.procedure_exists(TEXT,TEXT) IS
'/**
 * procedure_exists: Checks a schema for a procedure with the given name
 * @param TEXT: schema_name
 * @param TEXT: proc_name
 * @returns BOOLEAN
 **/';