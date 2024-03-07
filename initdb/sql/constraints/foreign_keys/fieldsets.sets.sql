ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_parent_fkey FOREIGN KEY (parent,parent) REFERENCES fieldsets.sets(id, parent) DEFERRED;
