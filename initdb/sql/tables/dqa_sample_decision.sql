-- public.fieldsets_sample_decision definition

-- Drop table

-- DROP TABLE public.fieldsets_sample_decision;

CREATE TABLE public.fieldsets_sample_decision (
	fieldsets_sample_decision_id serial4 NOT NULL,
	fieldsets_regime_version_id int4 NOT NULL,
	sample_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	decision int4 NOT NULL
);
