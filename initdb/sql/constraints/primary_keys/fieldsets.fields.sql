ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_id_pkey PRIMARY KEY (id);
ALTER TABLE fieldsets.fields ADD CONSTRAINT fields_token_unique UNIQUE (token);