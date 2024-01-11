CREATE INDEX fields_token_idx ON fieldsets.fields USING btree (token);
CREATE INDEX fields_parent_idx ON fieldsets.fields USING btree (parent);
CREATE INDEX fields_parent_token_idx ON fieldsets.fields USING btree (parent_token);
CREATE INDEX fields_meta_idx ON fieldsets.fields USING gin (meta);
