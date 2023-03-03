ALTER TABLE public.fieldsets_batch_decision ADD CONSTRAINT fieldsets_batch_decision_id UNIQUE (fieldsets_regime_version_id, batch_id, execution_id);
ALTER TABLE public.fieldsets_batch_decision ADD CONSTRAINT fieldsets_batch_decision_pkey PRIMARY KEY (fieldsets_batch_decision_id);
