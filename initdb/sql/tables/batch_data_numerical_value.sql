-- public.batch_data_numerical_value definition

-- Drop table

-- DROP TABLE public.batch_data_numerical_value;

CREATE TABLE public.batch_data_numerical_value (
	batch_id int4 NOT NULL,
	batch_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	batch_data_value float8 NOT NULL
);
