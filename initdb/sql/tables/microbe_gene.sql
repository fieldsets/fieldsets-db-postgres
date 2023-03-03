-- public.microbe_gene definition

-- Drop table

-- DROP TABLE public.microbe_gene;

CREATE TABLE public.microbe_gene (
	gene_id serial4 NOT NULL,
	microbe_gene_catalog_id int4 NOT NULL,
	gene_name varchar NOT NULL
);
