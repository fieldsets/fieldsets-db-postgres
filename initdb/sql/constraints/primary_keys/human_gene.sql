ALTER TABLE public.human_gene ADD CONSTRAINT human_gene_human_gene_catalog_id_human_gene_id_key UNIQUE (human_gene_catalog_id, human_gene_id);
ALTER TABLE public.human_gene ADD CONSTRAINT human_gene_human_gene_catalog_id_human_gene_name_key UNIQUE (human_gene_catalog_id, source_gene_id);
ALTER TABLE public.human_gene ADD CONSTRAINT human_gene_pkey PRIMARY KEY (human_gene_id);
