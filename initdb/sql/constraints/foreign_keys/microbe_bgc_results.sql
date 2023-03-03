-- public.microbe_bgc_results foreign keys
ALTER TABLE public.microbe_bgc_results ADD CONSTRAINT microbe_bgc_results_analysis_id_fkey FOREIGN KEY (analysis_id) REFERENCES public.analysis(analysis_id);
ALTER TABLE public.microbe_bgc_results ADD CONSTRAINT microbe_bgc_results_bgc_id_fkey FOREIGN KEY (bgc_id) REFERENCES public.microbe_bgc(bgc_id);
ALTER TABLE public.microbe_bgc_results ADD CONSTRAINT microbe_bgc_results_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES public.microbe_genome(genome_id);