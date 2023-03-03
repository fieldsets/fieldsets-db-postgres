-- public.microbiome_function_results definition

-- Drop table

-- DROP TABLE public.microbiome_function_results;

CREATE TABLE public.microbiome_function_results (
	analysis_id int4 NOT NULL,
	function_id int4 NOT NULL,
	readcount float8 NOT NULL
);
