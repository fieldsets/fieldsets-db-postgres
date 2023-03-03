-- public.microbe_gene_catalog definition

-- Drop table

-- DROP TABLE public.microbe_gene_catalog;

CREATE TABLE public.microbe_gene_catalog (
	microbe_gene_catalog_id serial4 NOT NULL,
	microbe_gene_catalog_name varchar NOT NULL,
	created timestamp NOT NULL
);