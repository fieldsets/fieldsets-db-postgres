ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_parent_fkey FOREIGN KEY (parent) REFERENCES fieldsets.fieldsets(id) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_set_fkey FOREIGN KEY (set_id) REFERENCES fieldsets.sets(id) DEFERRABLE;
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_field_fkey FOREIGN KEY (field_id) REFERENCES fieldsets.fields(id) DEFERRABLE;
