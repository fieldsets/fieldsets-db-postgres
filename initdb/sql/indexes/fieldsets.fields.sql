CREATE INDEX fields_token_idx ON fieldsets.fields USING btree (token);
CREATE INDEX fields_meta_idx ON fieldsets.fields USING gin (meta);
