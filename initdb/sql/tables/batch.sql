-- public.batch definition

-- Drop table

-- DROP TABLE public.batch;

CREATE TABLE public.batch (
	batch_id serial4 NOT NULL,
	flowcell_id int4 NOT NULL,
	batch_name varchar NOT NULL
);
