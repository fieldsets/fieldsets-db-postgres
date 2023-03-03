-- public.sample definition

-- Drop table

-- DROP TABLE public.sample;

CREATE TABLE public.sample (
	sample_id serial4 NOT NULL,
	sample_name varchar NOT NULL,
	plate_position int4 NOT NULL,
	batch_id int4 NOT NULL,
	flowcell_id int4 NOT NULL,
	sample_name_lims varchar NULL
);
