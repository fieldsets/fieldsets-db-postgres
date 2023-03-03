ALTER TABLE public.analysis_pipeline ADD CONSTRAINT analysis_pipeline_analysis_pipeline_name_key UNIQUE (analysis_pipeline_name);
ALTER TABLE public.analysis_pipeline ADD CONSTRAINT analysis_pipeline_pkey PRIMARY KEY (analysis_pipeline_id);
