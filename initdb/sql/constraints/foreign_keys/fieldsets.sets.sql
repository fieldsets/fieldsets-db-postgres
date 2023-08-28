ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_parent_fkey FOREIGN KEY (parent) REFERENCES fieldsets.sets(id) INITIALLY DEFERRED;
