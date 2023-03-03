ALTER TABLE public.value_type ADD CONSTRAINT value_type_pkey PRIMARY KEY (value_type_id);
ALTER TABLE public.value_type ADD CONSTRAINT value_type_value_type_name_key UNIQUE (value_type_name);
