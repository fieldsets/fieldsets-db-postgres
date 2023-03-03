-- public.microbe_bgc definition

-- Drop table

-- DROP TABLE public.microbe_bgc;

CREATE TABLE public.microbe_bgc (
	bgc_id serial4 NOT NULL,
	microbe_bgc_catalog_id int4 NOT NULL,
	bgc_name varchar NOT NULL,
	bgc_type varchar NOT NULL,
	genome_id int4 NOT NULL,
	microbe_bgc_to_genome_map_id int4 NOT NULL,
	bgc_type_score float8 NULL,
	bgc_product_activity varchar NULL,
	bgc_activity_score float8 NULL
);
