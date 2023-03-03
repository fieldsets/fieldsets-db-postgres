-- public.taxonomy_tree_wide index
CREATE INDEX events_token_idx ON pipeline.events USING btree (event_token);

CREATE INDEX events_json_idx ON pipeline.events USING gin (meta_data);
