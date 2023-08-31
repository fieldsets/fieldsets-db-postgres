ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_parent_fkey FOREIGN KEY (parent,parent) REFERENCES fieldsets.fields(id,parent) INITIALLY DEFERRED;
