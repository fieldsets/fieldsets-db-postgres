-- public.microbiome_genome_results definition

-- Drop table

-- DROP TABLE public.microbiome_genome_results;

CREATE TABLE public.microbiome_genome_results (
	analysis_id int4 NOT NULL,
	genome_id int4 NOT NULL,
	readcount float8 NOT NULL
);
