/**
 * trigger_register_event: triggered before insert into event table. When an insert happens that is tagged as an event, rewrite data for events table structure using metadata.
 * @depends TRIGGER: register_event
 **/
CREATE OR REPLACE FUNCTION pipeline.trigger_register_event() RETURNS trigger AS $function$
  DECLARE
    insert_sql TEXT;
    event_status pipeline.FIELDSETS_EVENT_STATUS := 'pending';
    event_pipeline TEXT := 'all';
    event_meta JSONB := '{}'::JSONB;
    event_data JSONB;
    event_record RECORD;
    json_dump JSONB;
  BEGIN 
    IF NEW.meta_data ? 'meta_data' THEN
      event_data := to_jsonb(NEW.meta_data);
      IF event_data ? 'meta_data' THEN
        event_meta := event_data -> 'meta_data';
      END IF;
      IF event_data ? 'event_status' THEN
        event_status := CAST (event_data ->> 'event_status' AS pipeline.FIELDSETS_EVENT_STATUS);
      END IF;
      IF event_data ? 'pipeline' THEN
        event_pipeline := event_data ->> 'pipeline';
      END IF;
      SELECT event_data ->> 'fieldsets_event' AS "event_token", NEW.created AS "created", event_meta AS "meta_data", NEW.event_id AS "event_id", event_pipeline AS "pipeline", event_status AS "event_status", NEW.updated AS "updated" INTO event_record;
      RETURN event_record;
    ELSE 
      RETURN NEW;
    END IF;
  END;
$function$ LANGUAGE plpgsql;

COMMENT ON FUNCTION pipeline.trigger_register_event () IS 
'/**
 * trigger_register_event: triggered before insert into events table. When an insert happens that is tagged as an event, rewrite data for events table structure using metadata.
 * @depends TRIGGER: register_event
 **/';