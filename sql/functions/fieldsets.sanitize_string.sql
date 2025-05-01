/**
 * sanitize_string: Remove new lines, carriage returns and compress white space of a string.
 * @param string TEXT
 * @return TEXT
 * @example `SELECT sanitize_string('hello');`
 **/
CREATE OR REPLACE FUNCTION fieldsets.sanitize_string(string TEXT) RETURNS TEXT
AS
$function$
BEGIN
  RETURN regexp_replace(trim(regexp_replace(string, '[\n\r\t]+', ' ', 'g')),'[\s+]', ' ', 'g');
END;
$function$
LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.sanitize_string (TEXT) IS 
'/**
 * sanitize_string: Remove new lines, carriage returns and compress white space of a string.
 * @param string TEXT
 * @return TEXT
 * @example `SELECT sanitize_string(''hello'');`
 **/';