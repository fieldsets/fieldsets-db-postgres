ALTER TABLE public.microbe_genome ADD CONSTRAINT microbe_genome_microbe_genome_catalog_id_genome_name_key UNIQUE (microbe_genome_catalog_id, genome_name);
ALTER TABLE public.microbe_genome ADD CONSTRAINT microbe_genome_pkey PRIMARY KEY (genome_id);
