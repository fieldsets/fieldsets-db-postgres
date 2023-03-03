ALTER TABLE public.flowcell ADD CONSTRAINT flowcell_illumina_uuid_key UNIQUE (illumina_uuid);
ALTER TABLE public.flowcell ADD CONSTRAINT flowcell_pkey PRIMARY KEY (flowcell_id);