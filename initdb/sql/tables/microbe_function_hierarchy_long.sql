-- public.microbe_function_hierarchy_long definition

-- Drop table

-- DROP TABLE public.microbe_function_hierarchy_long;

CREATE TABLE public.microbe_function_hierarchy_long (
	microbe_function_hierarchy_catalog_id int4 NOT NULL,
	function_id int4 NOT NULL,
	parent_id int4 NOT NULL
);
