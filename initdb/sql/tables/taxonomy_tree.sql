-- public.taxonomy_tree definition

-- Drop table

-- DROP TABLE public.taxonomy_tree;

CREATE TABLE public.taxonomy_tree (
	taxonomy_tree_id serial4 NOT NULL,
	taxonomy_tree_name varchar NOT NULL,
	created timestamp NOT NULL
);