-- public.taxonomy_tree_wide index
CREATE INDEX config_token_idx ON pipeline.config USING btree (config_token);

CREATE INDEX config_json_idx ON pipeline.config USING gin (config_data);
