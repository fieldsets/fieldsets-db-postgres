ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_parent_fkey FOREIGN KEY (parent, store) REFERENCES fieldsets.fields(id, store);
