-- public.analysis_pipeline_version definition

-- Drop table

-- DROP TABLE public.analysis_pipeline_version;

CREATE TABLE public.analysis_pipeline_version (
	analysis_pipeline_version_id serial4 NOT NULL,
	analysis_pipeline_id int4 NOT NULL,
	analysis_pipeline_version_name varchar NOT NULL,
	created timestamp NOT NULL
);
