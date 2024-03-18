ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_parent_fkey FOREIGN KEY (parent) REFERENCES fieldsets.fields(id) DEFERRABLE;
