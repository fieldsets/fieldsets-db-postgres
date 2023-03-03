-- public.microbe_genome_catalog definition

-- Drop table

-- DROP TABLE public.microbe_genome_catalog;

CREATE TABLE public.microbe_genome_catalog (
	microbe_genome_catalog_id serial4 NOT NULL,
	microbe_genome_catalog_name varchar NOT NULL,
	created timestamp NOT NULL
);