-- public.analysis_data_string_value definition

-- Drop table

-- DROP TABLE public.analysis_data_string_value;

CREATE TABLE public.analysis_data_string_value (
	analysis_id int4 NOT NULL,
	analysis_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	analysis_data_value varchar NOT NULL
);
