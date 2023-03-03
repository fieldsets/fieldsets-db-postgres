-- public.analysis_data_definition definition

-- Drop table

-- DROP TABLE public.analysis_data_definition;

CREATE TABLE public.analysis_data_definition (
	analysis_data_id serial4 NOT NULL,
	analysis_data_group varchar NOT NULL,
	analysis_data_name varchar NOT NULL,
	analysis_data_type int4 NOT NULL
);
