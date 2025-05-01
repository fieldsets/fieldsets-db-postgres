/**
 * trigger_set_updated_timestamp: triggered before insert. Set updated field to current time
 * @depends TRIGGER: set_${TABLE_NAME}_updated_timestamp
 **/
CREATE OR REPLACE FUNCTION public.trigger_set_updated_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.trigger_set_updated_timestamp () IS 
'/**
 * trigger_set_updated_timestamp: triggered before insert. Set updated field to current time
 * @depends TRIGGER: set_${TABLE_NAME}_updated_timestamp
 **/';
