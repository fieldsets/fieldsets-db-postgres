-- public.microbe_gene_to_genome definition

-- Drop table

-- DROP TABLE public.microbe_gene_to_genome;

CREATE TABLE public.microbe_gene_to_genome (
	microbe_gene_to_genome_map_id int4 NOT NULL,
	gene_id int4 NOT NULL,
	genome_id int4 NOT NULL
);
