-- public.microbiome_genome_results index
CREATE INDEX microbiome_genome_results_microbe_genome_idx ON public.microbiome_genome_results USING btree (genome_id);
CREATE INDEX microbiome_genome_results_udx_aid ON public.microbiome_genome_results USING btree (analysis_id);
