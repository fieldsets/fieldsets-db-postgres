ALTER TABLE fieldsets.tokens ADD CONSTRAINT tokens_id_fkey FOREIGN KEY (id) REFERENCES fieldsets.fieldsets(id) DEFERRABLE;
ALTER TABLE fieldsets.tokens ADD CONSTRAINT tokens_token_fkey FOREIGN KEY (token) REFERENCES fieldsets.fieldsets(token) DEFERRABLE;
