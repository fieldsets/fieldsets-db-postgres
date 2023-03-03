-- public.human_transcript foreign keys
ALTER TABLE public.human_transcript ADD CONSTRAINT human_transcript_human_gene_catalog_id_fkey FOREIGN KEY (human_gene_catalog_id) REFERENCES public.human_gene_catalog(human_gene_catalog_id);
ALTER TABLE public.human_transcript ADD CONSTRAINT human_transcript_human_gene_id_fkey FOREIGN KEY (human_gene_id) REFERENCES public.human_gene(human_gene_id);