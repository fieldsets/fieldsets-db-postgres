ALTER TABLE public.microbe_gene ADD CONSTRAINT microbe_gene_microbe_gene_catalog_id_gene_name_key UNIQUE (microbe_gene_catalog_id, gene_name);
ALTER TABLE public.microbe_gene ADD CONSTRAINT microbe_gene_pkey PRIMARY KEY (gene_id);
