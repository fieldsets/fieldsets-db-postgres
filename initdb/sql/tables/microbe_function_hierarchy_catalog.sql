-- public.microbe_function_hierarchy_catalog definition

-- Drop table

-- DROP TABLE public.microbe_function_hierarchy_catalog;
CREATE SEQUENCE IF NOT EXISTS public.microbe_function_hierarchy_ca_microbe_function_hierarchy_ca_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE TABLE public.microbe_function_hierarchy_catalog (
	microbe_function_hierarchy_catalog_id int4 NOT NULL DEFAULT nextval('microbe_function_hierarchy_ca_microbe_function_hierarchy_ca_seq'::regclass),
	microbe_function_hierarchy_catalog_name varchar NOT NULL,
	created timestamp NOT NULL
);