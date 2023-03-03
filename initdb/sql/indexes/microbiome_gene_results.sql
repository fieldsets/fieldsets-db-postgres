-- public.microbiome_gene_results index
CREATE INDEX microbiome_gene_results_analysis_id_idx ON public.microbiome_gene_results USING btree (analysis_id);
