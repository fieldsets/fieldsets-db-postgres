-- public.microbe_bgc_catalog foreign keys
-- public.microbe_bgc_catalog foreign keys

ALTER TABLE public.microbe_bgc_catalog ADD CONSTRAINT microbe_bgc_catalog_microbe_genome_catalog_id_fkey FOREIGN KEY (microbe_genome_catalog_id) REFERENCES public.microbe_genome_catalog(microbe_genome_catalog_id);