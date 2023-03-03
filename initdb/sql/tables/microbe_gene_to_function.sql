-- public.microbe_gene_to_function definition

-- Drop table

-- DROP TABLE public.microbe_gene_to_function;

CREATE TABLE public.microbe_gene_to_function (
	microbe_gene_to_function_map_id int4 NOT NULL,
	gene_id int4 NOT NULL,
	function_id int4 NOT NULL
);
