CREATE INDEX pipeline_config_token_idx ON pipeline.config USING btree (config_token);
CREATE INDEX pipeline_config_json_idx ON pipeline.config USING gin (config_data);
