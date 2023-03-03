ALTER TABLE public.relative_abundance_current ADD CONSTRAINT cur_rel_abu_distinct_constr UNIQUE (analysis_id, sample_id, taxonomy_id, methodid);
