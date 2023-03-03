/**
 * fieldsets_emit_event: Create or Update an entry in the pipeline.events table
 * @param JSON: event_json
 */
CREATE OR REPLACE PROCEDURE pipeline.fieldsets_emit_event(event_json JSON) 
AS 
$procedure$
  DECLARE
    event_data JSONB;
    event_sql TEXT;
   	event_pipeline TEXT := 'all';
  	event_status pipeline.FIELDSETS_EVENT_STATUS := 'pending'::pipeline.FIELDSETS_EVENT_STATUS;
  	event_token TEXT := 'default';
  	event_meta JSONB := '{}'::JSONB;
  	event_id BIGINT;
  BEGIN
    event_data := to_jsonb(event_json);
    IF event_data ?& ARRAY['fieldsets_event', 'pipeline', 'meta_data'] THEN
    	IF event_data ? 'pipeline' THEN
      		event_pipeline := event_data ->> 'pipeline';
    	END IF;
    	IF event_data ? 'fieldsets_event' THEN
      		event_token := event_data ->> 'fieldsets_event';
    	END IF;
    	IF event_data ? 'event_status' THEN
      		event_status := CAST (event_data ->> 'event_status' AS pipeline.FIELDSETS_EVENT_STATUS);
    	END IF;
    	IF event_data ? 'meta_data' THEN
      		event_meta := event_data ->> 'meta_data';
    	END IF;
      IF event_data ? 'event_id' THEN
        -- Update existing event
      	event_id := cast(event_data -> 'event_id' AS BIGINT);
      	event_sql := format('UPDATE pipeline.events SET meta_data = %L, event_status = %L WHERE event_id = %L;', event_meta, event_status, event_id);
      ELSE
        -- Insert new event
      	event_sql := format('INSERT INTO pipeline.events(event_token,meta_data,pipeline,event_status) VALUES (%L,%L, %L, %L);', event_token, event_meta, event_pipeline, event_status);
      END IF;
    END IF;
	
    EXECUTE event_sql;
    
  END;
$procedure$ 
LANGUAGE plpgsql;

COMMENT ON PROCEDURE pipeline.fieldsets_emit_event (JSON) IS 
'/**
 * fieldsets_emit_event: Create or Update an entry in the pipeline.events table
 * @param TEXT: event_json
 */';

 