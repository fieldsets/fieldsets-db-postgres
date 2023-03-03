-- public.flowcell_data_numerical_value definition

-- Drop table

-- DROP TABLE public.flowcell_data_numerical_value;

CREATE TABLE public.flowcell_data_numerical_value (
	flowcell_id int4 NOT NULL,
	flowcell_data_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	flowcell_data_value float8 NOT NULL
);
