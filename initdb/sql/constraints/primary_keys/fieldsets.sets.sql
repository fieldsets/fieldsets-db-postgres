ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_id_pkey PRIMARY KEY (id, parent);
ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_id_token_unique UNIQUE (token, parent);
