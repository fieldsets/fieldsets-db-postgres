CREATE INDEX config_token_idx ON fieldsets.config USING btree (config_token);
CREATE INDEX config_json_idx ON fieldsets.config USING gin (config_data);
