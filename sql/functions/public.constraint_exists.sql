/**
 * constraint_exists: Checks a given table for a constraint with the given name
 * @param TEXT: schema_name (schema name)
 * @param TEXT: tbl_name (table name)
 * @param TEXT: const_name (constraint name)
 * @returns BOOLEAN
 **/
CREATE OR REPLACE FUNCTION public.constraint_exists (schema_name TEXT,tbl_name TEXT, const_name TEXT) RETURNS BOOLEAN
AS $function$
DECLARE
    const_exists BOOLEAN := FALSE;
BEGIN
    SELECT constraint_name IS NOT NULL
    INTO const_exists
    FROM information_schema.constraint_column_usage
    WHERE table_schema = schema_name AND
        table_name = tbl_name AND
        constraint_name = const_name;

    RETURN const_exists;
END;
$function$
STRICT
LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION public.constraint_exists(TEXT,TEXT,TEXT) IS
'/**
 * constraint_exists: Checks a given table for a constraint with the given name
 * @param TEXT: schema_name (schema name)
 * @param TEXT: tbl_name (table name)
 * @param TEXT: const_name (constraint name)
 * @returns BOOLEAN
 **/';

