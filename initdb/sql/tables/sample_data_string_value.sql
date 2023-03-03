-- public.sample_data_string_value definition

-- Drop table

-- DROP TABLE public.sample_data_string_value;

CREATE TABLE public.sample_data_string_value (
	sample_id int4 NOT NULL,
	sample_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	sample_data_value varchar NOT NULL
);
