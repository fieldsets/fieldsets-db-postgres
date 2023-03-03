-- public.taxonomy_tree_wide foreign keys
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey FOREIGN KEY (taxonomy_tree_id) REFERENCES public.taxonomy_tree(taxonomy_tree_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey1 FOREIGN KEY (taxonomy_tree_id,strain_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);

-- Segfauting on M1
/*
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey2 FOREIGN KEY (taxonomy_tree_id,species_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey3 FOREIGN KEY (taxonomy_tree_id,genus_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey4 FOREIGN KEY (taxonomy_tree_id,family_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey5 FOREIGN KEY (taxonomy_tree_id,order_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey6 FOREIGN KEY (taxonomy_tree_id,class_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey7 FOREIGN KEY (taxonomy_tree_id,phylum_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
ALTER TABLE public.taxonomy_tree_wide ADD CONSTRAINT taxonomy_tree_wide_taxonomy_tree_id_fkey8 FOREIGN KEY (taxonomy_tree_id,kingdom_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
*/