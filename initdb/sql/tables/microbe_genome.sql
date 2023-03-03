-- public.microbe_genome definition

-- Drop table

-- DROP TABLE public.microbe_genome;

CREATE TABLE public.microbe_genome (
	genome_id serial4 NOT NULL,
	microbe_genome_catalog_id int4 NOT NULL,
	genome_name varchar NOT NULL
);
