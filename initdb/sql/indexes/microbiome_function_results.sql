-- public.microbiome_function_results index
CREATE INDEX microbiome_function_results_aid_idx ON public.microbiome_function_results USING btree (analysis_id);
