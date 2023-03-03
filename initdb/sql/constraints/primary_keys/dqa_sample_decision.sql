ALTER TABLE public.fieldsets_sample_decision ADD CONSTRAINT fieldsets_sample_decision_id UNIQUE (fieldsets_regime_version_id, sample_id, execution_id);
ALTER TABLE public.fieldsets_sample_decision ADD CONSTRAINT fieldsets_sample_decision_pkey PRIMARY KEY (fieldsets_sample_decision_id);
