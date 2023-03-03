-- public.microbiome_gene_results foreign keys
ALTER TABLE public.microbiome_gene_results ADD CONSTRAINT microbiome_gene_results_analysis_id_fkey FOREIGN KEY (analysis_id) REFERENCES public.analysis(analysis_id);
ALTER TABLE public.microbiome_gene_results ADD CONSTRAINT microbiome_gene_results_gene_id_fkey FOREIGN KEY (gene_id) REFERENCES public.microbe_gene(gene_id);