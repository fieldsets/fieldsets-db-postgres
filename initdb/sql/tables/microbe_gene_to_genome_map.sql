-- public.microbe_gene_to_genome_map definition

-- Drop table

-- DROP TABLE public.microbe_gene_to_genome_map;

CREATE TABLE public.microbe_gene_to_genome_map (
	microbe_gene_to_genome_map_id serial4 NOT NULL,
	map_name varchar NOT NULL,
	created timestamp NOT NULL
);