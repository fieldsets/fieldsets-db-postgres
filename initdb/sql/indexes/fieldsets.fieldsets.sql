CREATE INDEX fieldsets_id_idx ON fieldsets.fieldsets USING btree (id);
CREATE INDEX fieldsets_parent_idx ON fieldsets.fieldsets USING btree (parent);
CREATE INDEX fieldsets_token_idx ON fieldsets.fieldsets USING btree (token);
CREATE INDEX fieldsets_set_token_idx ON fieldsets.fieldsets USING btree (set_token);
CREATE INDEX fieldsets_parent_token_idx ON fieldsets.fieldsets USING btree (parent_token);
CREATE INDEX fieldsets_store_idx ON fieldsets.fieldsets USING btree (store);
CREATE INDEX fieldsets_type_idx ON fieldsets.fieldsets USING btree (type);
