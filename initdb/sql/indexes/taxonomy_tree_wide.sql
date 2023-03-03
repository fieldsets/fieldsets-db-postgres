-- public.taxonomy_tree_wide index
CREATE INDEX taxonomy_tree_wide_assembly_accession_name_idx ON public.taxonomy_tree_wide USING btree (assembly_accession_name);
