CREATE INDEX sets_token_idx ON fieldsets.sets USING btree (token);
CREATE INDEX sets_meta_idx ON fieldsets.sets USING gin (meta);
