-- public.flowcell_data_definition definition

-- Drop table

-- DROP TABLE public.flowcell_data_definition;

CREATE TABLE public.flowcell_data_definition (
	flowcell_data_id serial4 NOT NULL,
	flowcell_data_group varchar NOT NULL,
	flowcell_data_name varchar NOT NULL,
	flowcell_data_type int4 NOT NULL
);
