-- public.human_gene_results index
CREATE INDEX human_gene_results_aid_idx ON public.human_gene_results USING btree (analysis_id);
