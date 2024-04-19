ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_id_fkey FOREIGN KEY (id) REFERENCES fieldsets.tokens(id) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_token_fkey FOREIGN KEY (token) REFERENCES fieldsets.tokens(token) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_parent_fkey FOREIGN KEY (parent) REFERENCES fieldsets.tokens(id) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_parent_token_fkey FOREIGN KEY (parent_token) REFERENCES fieldsets.tokens(token) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_set_id_fkey FOREIGN KEY (set_id) REFERENCES fieldsets.sets(id) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_set_token_fkey FOREIGN KEY (set_token) REFERENCES fieldsets.sets(token) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_field_id_fkey FOREIGN KEY (field_id) REFERENCES fieldsets.fields(id) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_field_token_fkey FOREIGN KEY (field_token) REFERENCES fieldsets.fields(token) DEFERRABLE;
