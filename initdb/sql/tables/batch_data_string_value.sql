-- public.batch_data_string_value definition

-- Drop table

-- DROP TABLE public.batch_data_string_value;

CREATE TABLE public.batch_data_string_value (
	batch_id int4 NOT NULL,
	batch_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	batch_data_value varchar NOT NULL
);
