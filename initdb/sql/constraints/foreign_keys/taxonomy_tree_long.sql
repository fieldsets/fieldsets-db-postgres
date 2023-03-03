-- public.taxonomy_tree_long foreign keys
ALTER TABLE public.taxonomy_tree_long ADD CONSTRAINT taxonomy_tree_long_taxonomy_tree_id_fkey FOREIGN KEY (taxonomy_tree_id) REFERENCES public.taxonomy_tree(taxonomy_tree_id);
ALTER TABLE public.taxonomy_tree_long ADD CONSTRAINT taxonomy_tree_long_taxonomy_tree_id_fkey1 FOREIGN KEY (taxonomy_tree_id,parentid) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
-- This breaks when using M1 architecture with a seg fault. Fix.
--ALTER TABLE public.taxonomy_tree_long ADD CONSTRAINT taxonomy_tree_long_taxonomy_tree_id_fkey2 FOREIGN KEY (taxonomy_tree_id,kingdom_taxonomy_id) REFERENCES public.taxonomy_tree_long(taxonomy_tree_id,taxonomy_id);
