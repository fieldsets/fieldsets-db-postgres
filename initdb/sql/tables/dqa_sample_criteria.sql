-- public.fieldsets_sample_criteria definition

-- Drop table

-- DROP TABLE public.fieldsets_sample_criteria;

CREATE TABLE public.fieldsets_sample_criteria (
	fieldsets_sample_criteria_id serial4 NOT NULL,
	fieldsets_regime_version_id int4 NOT NULL,
	criteria_name varchar NOT NULL,
	threshold float8 NOT NULL
);
