ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_id_pkey PRIMARY KEY (id);
ALTER TABLE fieldsets.sets ADD CONSTRAINT sets_token_unique UNIQUE (token);