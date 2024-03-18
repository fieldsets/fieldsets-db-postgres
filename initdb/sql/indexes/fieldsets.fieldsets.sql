CREATE INDEX fieldsets_store_idx ON fieldsets.fields USING btree (store);
CREATE INDEX fieldsets_type_idx ON fieldsets.fields USING btree (type);
