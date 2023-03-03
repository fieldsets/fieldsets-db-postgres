-- public.microbiome_genome_results foreign keys
ALTER TABLE public.microbiome_genome_results ADD CONSTRAINT microbiome_genome_results_analysis_id_fkey FOREIGN KEY (analysis_id) REFERENCES public.analysis(analysis_id);
ALTER TABLE public.microbiome_genome_results ADD CONSTRAINT microbiome_genome_results_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES public.microbe_genome(genome_id);