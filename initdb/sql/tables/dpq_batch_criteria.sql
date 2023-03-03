CREATE TABLE IF NOT EXISTS public.fieldsets_batch_criteria (
	fieldsets_batch_criteria_id serial4 NOT NULL,
	fieldsets_regime_version_id int4 NOT NULL,
	criteria_name varchar NOT NULL,
	threshold float8 NOT NULL
);
