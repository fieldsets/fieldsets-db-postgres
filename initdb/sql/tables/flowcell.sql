-- public.flowcell definition

-- Drop table

-- DROP TABLE public.flowcell;

CREATE TABLE public.flowcell (
	flowcell_id serial4 NOT NULL,
	illumina_uuid varchar NOT NULL,
	run_name varchar NOT NULL,
	run_date timestamp NOT NULL
);