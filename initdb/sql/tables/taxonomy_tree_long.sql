-- public.taxonomy_tree_long definition

-- Drop table

-- DROP TABLE public.taxonomy_tree_long;

CREATE TABLE public.taxonomy_tree_long (
	taxonomy_tree_id int4 NOT NULL,
	taxonomy_id varchar(100) NOT NULL,
	parentid varchar(100) NOT NULL,
	taxonomy_rank varchar(100) NOT NULL,
	taxonomy_name varchar(1000) NOT NULL,
	kingdom_taxonomy_id varchar(100) NOT NULL,
	kingdom_name varchar(100) NOT NULL
);
