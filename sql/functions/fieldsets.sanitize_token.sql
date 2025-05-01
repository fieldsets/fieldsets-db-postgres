/**
 * sanitize_token: Allow only [a-z0-9_] characters in a string.
 * @param TEXT: text_string
 **/
CREATE OR REPLACE FUNCTION fieldsets.sanitize_token(token_string TEXT)
RETURNS TEXT
AS $function$
    BEGIN
        RETURN regexp_replace(lower(token_string),'![a-z0-9_]','_','g');
    END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fieldsets.sanitize_token(TEXT) IS
'/**
 * sanitize_token: Allow only [a-z0-9_] characters in a string.
 * @param TEXT: text_string
 **/';
