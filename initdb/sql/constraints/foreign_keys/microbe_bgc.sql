-- public.microbe_bgc foreign keys
ALTER TABLE public.microbe_bgc ADD CONSTRAINT microbe_bgc_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES public.microbe_genome(genome_id);
ALTER TABLE public.microbe_bgc ADD CONSTRAINT microbe_bgc_microbe_bgc_catalog_id_fkey FOREIGN KEY (microbe_bgc_catalog_id) REFERENCES public.microbe_bgc_catalog(microbe_bgc_catalog_id);
ALTER TABLE public.microbe_bgc ADD CONSTRAINT microbe_bgc_microbe_bgc_to_genome_map_id_fkey FOREIGN KEY (microbe_bgc_to_genome_map_id) REFERENCES public.microbe_bgc_to_genome_map(microbe_bgc_to_genome_map_id);