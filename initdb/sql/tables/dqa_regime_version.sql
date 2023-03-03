-- public.fieldsets_regime_version definition

-- Drop table

-- DROP TABLE public.fieldsets_regime_version;

CREATE TABLE public.fieldsets_regime_version (
	fieldsets_regime_version_id serial4 NOT NULL,
	fieldsets_regime_version_name varchar NOT NULL,
	fieldsets_regime_id int4 NOT NULL
);
