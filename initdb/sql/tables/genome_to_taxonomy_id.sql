-- public.genome_to_taxonomy_id definition

-- Drop table

-- DROP TABLE public.genome_to_taxonomy_id;

CREATE TABLE public.genome_to_taxonomy_id (
	genome_to_taxonomy_id_map_id int4 NOT NULL,
	taxonomy_id varchar(100) NOT NULL,
	genome_id int4 NOT NULL
);
