ALTER TABLE public.batch ADD CONSTRAINT batch_flowcell_id_batch_name_key UNIQUE (flowcell_id, batch_name);
ALTER TABLE public.batch ADD CONSTRAINT batch_pkey PRIMARY KEY (batch_id);
