-- public.microbe_function definition

-- Drop table

-- DROP TABLE public.microbe_function;

CREATE TABLE public.microbe_function (
	function_id serial4 NOT NULL,
	function_name varchar NOT NULL,
	microbe_function_catalog_id int4 NOT NULL,
	function_entry varchar NOT NULL,
	function_definition varchar NOT NULL
);
