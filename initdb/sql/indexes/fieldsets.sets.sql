CREATE INDEX sets_parent_idx ON fieldsets.sets USING btree (parent);
CREATE INDEX sets_parent_token_idx ON fieldsets.sets USING btree (parent_token);
CREATE INDEX sets_meta_idx ON fieldsets.sets USING gin (meta);
