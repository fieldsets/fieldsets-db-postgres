-- public.fieldsets_batch_decision definition

-- Drop table

-- DROP TABLE public.fieldsets_batch_decision;

CREATE TABLE public.fieldsets_batch_decision (
	fieldsets_batch_decision_id serial4 NOT NULL,
	fieldsets_regime_version_id int4 NOT NULL,
	batch_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	decision int4 NOT NULL
);
