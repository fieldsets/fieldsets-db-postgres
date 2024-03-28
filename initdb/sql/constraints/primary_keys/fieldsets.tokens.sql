ALTER TABLE fieldsets.tokens ADD CONSTRAINT tokens_id_pkey PRIMARY KEY (id);
ALTER TABLE fieldsets.tokens ADD CONSTRAINT tokens_token_unique UNIQUE (token);
