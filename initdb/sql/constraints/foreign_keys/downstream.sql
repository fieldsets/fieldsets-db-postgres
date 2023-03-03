-- public.downstream foreign keys
ALTER TABLE public.downstream ADD CONSTRAINT downstream_analysis_id_fkey FOREIGN KEY (analysis_id) REFERENCES public.analysis(analysis_id);