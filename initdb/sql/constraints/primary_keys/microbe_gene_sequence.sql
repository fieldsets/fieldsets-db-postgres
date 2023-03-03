ALTER TABLE public.microbe_gene_sequence ADD CONSTRAINT microbe_gene_sequence_gene_id_sequence_name_key UNIQUE (gene_id, sequence_name);
ALTER TABLE public.microbe_gene_sequence ADD CONSTRAINT microbe_gene_sequence_pkey PRIMARY KEY (microbe_gene_sequence_id);
