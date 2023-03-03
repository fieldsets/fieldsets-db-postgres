-- public.relative_abundance_current definition

-- Drop table

-- DROP TABLE public.relative_abundance_current;

CREATE TABLE public.relative_abundance_current (
	analysis_id int8 NULL,
	sample_id int8 NULL,
	taxonomy_tree_id int4 NULL,
	taxonomy_name varchar(400) NOT NULL,
	taxonomy_id varchar(100) NULL,
	relativeabundance float8 NOT NULL,
	readcount int8 NOT NULL,
	methodid int8 NULL
);
