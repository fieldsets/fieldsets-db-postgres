-- public.microbe_genome index
CREATE INDEX microbe_genome_genome_name_idx ON public.microbe_genome USING btree (genome_name);
