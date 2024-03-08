CREATE INDEX fields_type_idx ON fieldsets.fields USING btree (type);
CREATE INDEX fields_meta_idx ON fieldsets.fields USING gin (meta);
