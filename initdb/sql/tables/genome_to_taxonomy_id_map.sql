-- public.genome_to_taxonomy_id_map definition

-- Drop table

-- DROP TABLE public.genome_to_taxonomy_id_map;

CREATE TABLE public.genome_to_taxonomy_id_map (
	genome_to_taxonomy_id_map_id serial4 NOT NULL,
	taxonomy_tree_id int4 NOT NULL,
	microbe_genome_catalog_id int4 NOT NULL
);
