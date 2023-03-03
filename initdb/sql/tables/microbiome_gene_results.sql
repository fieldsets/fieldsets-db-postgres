-- public.microbiome_gene_results definition

-- Drop table

-- DROP TABLE public.microbiome_gene_results;

CREATE TABLE public.microbiome_gene_results (
	analysis_id int4 NOT NULL,
	gene_id int4 NOT NULL,
	readcount float8 NOT NULL
);
