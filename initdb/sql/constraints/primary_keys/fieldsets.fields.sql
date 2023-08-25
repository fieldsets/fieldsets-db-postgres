ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_id_pkey PRIMARY KEY (id, store);
ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_token_unique UNIQUE (token, store);