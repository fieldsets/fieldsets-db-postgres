-- public.microbe_bgc_data_numerical_value definition

-- Drop table

-- DROP TABLE public.microbe_bgc_data_numerical_value;

CREATE TABLE public.microbe_bgc_data_numerical_value (
	bgc_id int4 NOT NULL,
	bgc_data_id int4 NOT NULL,
	bgc_data_value float8 NOT NULL
);
