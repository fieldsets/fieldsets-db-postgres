-- public.analysis foreign keys
ALTER TABLE public.analysis ADD CONSTRAINT analysis_analysis_pipeline_version_id_fkey FOREIGN KEY (analysis_pipeline_version_id) REFERENCES public.analysis_pipeline_version(analysis_pipeline_version_id);
ALTER TABLE public.analysis ADD CONSTRAINT analysis_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution(execution_id);
ALTER TABLE public.analysis ADD CONSTRAINT analysis_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);