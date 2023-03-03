ALTER TABLE public.taxonomy_tree ADD CONSTRAINT taxonomy_tree_pkey PRIMARY KEY (taxonomy_tree_id);
ALTER TABLE public.taxonomy_tree ADD CONSTRAINT taxonomy_tree_taxonomy_tree_name_key UNIQUE (taxonomy_tree_name);
