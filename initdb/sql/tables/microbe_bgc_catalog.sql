-- public.microbe_bgc_catalog definition

-- Drop table

-- DROP TABLE public.microbe_bgc_catalog;

CREATE TABLE public.microbe_bgc_catalog (
	microbe_bgc_catalog_id serial4 NOT NULL,
	microbe_bgc_catalog_name varchar NOT NULL,
	microbe_genome_catalog_id int4 NOT NULL,
	created timestamp NOT NULL
);
