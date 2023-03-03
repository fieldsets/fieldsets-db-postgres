-- public.taxonomy_tree_wide definition

-- Drop table

-- DROP TABLE public.taxonomy_tree_wide;

CREATE TABLE public.taxonomy_tree_wide (
	taxonomy_tree_id int4 NOT NULL,
	strain_taxonomy_id varchar(100) NULL,
	strain_name varchar(1000) NULL,
	species_taxonomy_id varchar(100) NULL,
	species_name varchar(1000) NULL,
	genus_taxonomy_id varchar(100) NULL,
	genus_name varchar(1000) NULL,
	family_taxonomy_id varchar(100) NULL,
	family_name varchar(1000) NULL,
	order_taxonomy_id varchar(100) NULL,
	order_name varchar(1000) NULL,
	class_taxonomy_id varchar(100) NULL,
	class_name varchar(1000) NULL,
	phylum_taxonomy_id varchar(100) NULL,
	phylum_name varchar(1000) NULL,
	kingdom_taxonomy_id varchar(100) NULL,
	kingdom_name varchar(1000) NULL,
	assembly_accession_name varchar(1000) NOT NULL
);
