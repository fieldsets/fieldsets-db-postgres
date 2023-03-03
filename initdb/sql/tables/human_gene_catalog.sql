-- public.human_gene_catalog definition

-- Drop table

-- DROP TABLE public.human_gene_catalog;

CREATE TABLE public.human_gene_catalog (
	human_gene_catalog_id serial4 NOT NULL,
	human_gene_catalog_name varchar NOT NULL,
	created timestamp NOT NULL
);