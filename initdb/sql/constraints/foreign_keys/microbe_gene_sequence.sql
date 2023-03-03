-- public.microbe_gene_sequence foreign keys
ALTER TABLE public.microbe_gene_sequence ADD CONSTRAINT microbe_gene_sequence_gene_id_fkey FOREIGN KEY (gene_id) REFERENCES public.microbe_gene(gene_id);