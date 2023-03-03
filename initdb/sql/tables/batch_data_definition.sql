-- public.batch_data_definition definition

-- Drop table

-- DROP TABLE public.batch_data_definition;

CREATE TABLE public.batch_data_definition (
	batch_data_id serial4 NOT NULL,
	batch_data_group varchar NOT NULL,
	batch_data_name varchar NOT NULL,
	batch_data_type int4 NOT NULL
);
