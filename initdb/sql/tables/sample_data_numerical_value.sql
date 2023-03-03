-- public.sample_data_numerical_value definition

-- Drop table

-- DROP TABLE public.sample_data_numerical_value;

CREATE TABLE public.sample_data_numerical_value (
	sample_id int4 NOT NULL,
	sample_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	sample_data_value float8 NOT NULL
);
