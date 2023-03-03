-- public.analysis definition

-- Drop table

-- DROP TABLE public.analysis;

CREATE TABLE public.analysis (
	analysis_id serial4 NOT NULL,
	analysis_pipeline_version_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	sample_id int4 NOT NULL
);
