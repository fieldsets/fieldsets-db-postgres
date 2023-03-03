-- public.microbe_gene_to_genome index
CREATE INDEX microbe_gene_to_genome_geid_idx ON public.microbe_gene_to_genome USING btree (gene_id);
CREATE INDEX microbe_gene_to_genome_gnid_idx ON public.microbe_gene_to_genome USING btree (genome_id);
CREATE INDEX microbe_gene_to_genome_mid_idx ON public.microbe_gene_to_genome USING btree (microbe_gene_to_genome_map_id);
