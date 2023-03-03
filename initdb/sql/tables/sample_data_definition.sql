-- public.sample_data_definition definition

-- Drop table

-- DROP TABLE public.sample_data_definition;

CREATE TABLE public.sample_data_definition (
	sample_data_id serial4 NOT NULL,
	sample_data_group varchar NOT NULL,
	sample_data_name varchar NOT NULL,
	sample_data_type int4 NOT NULL
);
