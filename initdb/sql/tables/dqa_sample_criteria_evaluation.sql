-- public.fieldsets_sample_criteria_evaluation definition

-- Drop table

-- DROP TABLE public.fieldsets_sample_criteria_evaluation;

CREATE SEQUENCE IF NOT EXISTS public.fieldsets_sample_criteria_evaluatio_fieldsets_sample_criteria_evaluatio_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
	
CREATE TABLE public.fieldsets_sample_criteria_evaluation (
	fieldsets_sample_criteria_evaluation_id int4 NOT NULL DEFAULT nextval('fieldsets_sample_criteria_evaluatio_fieldsets_sample_criteria_evaluatio_seq'::regclass),
	sample_id int4 NOT NULL,
	fieldsets_sample_criteria_id int4 NOT NULL,
	execution_id int4 NOT NULL,
	decision int4 NOT NULL,
	fieldsets_sample_criteria_value float8 NULL
);
