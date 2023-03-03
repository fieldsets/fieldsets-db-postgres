-- public.microbe_bgc_data_definition definition

-- Drop table

-- DROP TABLE public.microbe_bgc_data_definition;

CREATE TABLE public.microbe_bgc_data_definition (
	microbe_bgc_data_id serial4 NOT NULL,
	microbe_bgc_data_group varchar NOT NULL,
	microbe_bgc_data_name varchar NOT NULL,
	microbe_bgc_data_type int4 NOT NULL
);
