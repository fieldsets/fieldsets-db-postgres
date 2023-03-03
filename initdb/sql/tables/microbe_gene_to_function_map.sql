-- public.microbe_gene_to_function_map definition

-- Drop table

-- DROP TABLE public.microbe_gene_to_function_map;
CREATE SEQUENCE IF NOT EXISTS public.microbe_gene_to_function_map_microbe_gene_to_function_map_i_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE TABLE public.microbe_gene_to_function_map (
	microbe_gene_to_function_map_id int4 NOT NULL DEFAULT nextval('microbe_gene_to_function_map_microbe_gene_to_function_map_i_seq'::regclass),
	map_name varchar NOT NULL,
	created timestamp NOT NULL
);