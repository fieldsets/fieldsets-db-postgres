-- public.microbe_bgc_results definition

-- Drop table

-- DROP TABLE public.microbe_bgc_results;

CREATE TABLE public.microbe_bgc_results (
	analysis_id int4 NOT NULL,
	genome_id int4 NULL,
	bgc_id int4 NOT NULL,
	readcount float8 NOT NULL
);
