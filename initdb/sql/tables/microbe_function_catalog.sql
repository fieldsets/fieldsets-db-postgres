-- public.microbe_function_catalog definition

-- Drop table

-- DROP TABLE public.microbe_function_catalog;

CREATE TABLE public.microbe_function_catalog (
	microbe_function_catalog_id serial4 NOT NULL,
	microbe_function_catalog_name varchar NOT NULL,
	created timestamp NOT NULL
);