-- public.flowcell_data_string_value definition

-- Drop table

-- DROP TABLE public.flowcell_data_string_value;

CREATE TABLE public.flowcell_data_string_value (
	flowcell_id int4 NOT NULL,
	flowcell_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	flowcell_data_value varchar NOT NULL
);
