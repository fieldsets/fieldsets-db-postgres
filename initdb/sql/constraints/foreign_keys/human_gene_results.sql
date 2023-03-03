-- public.human_gene_results foreign keys
ALTER TABLE public.human_gene_results ADD CONSTRAINT human_gene_results_analysis_id_fkey FOREIGN KEY (analysis_id) REFERENCES public.analysis(analysis_id);