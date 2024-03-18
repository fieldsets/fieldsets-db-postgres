ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_id_pkey PRIMARY KEY (id,set_id,parent);
ALTER TABLE fieldsets.fieldsets ADD CONSTRAINT fieldsets_token_unique UNIQUE (token,set_token,parent_token);
