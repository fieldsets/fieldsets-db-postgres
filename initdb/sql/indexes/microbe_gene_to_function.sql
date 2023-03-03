-- public.microbe_gene_to_function index
CREATE INDEX microbe_gene_to_function_fid_idx ON public.microbe_gene_to_function USING btree (function_id);
CREATE INDEX microbe_gene_to_function_gid_idx ON public.microbe_gene_to_function USING btree (gene_id);
CREATE INDEX microbe_gene_to_function_mid_idx ON public.microbe_gene_to_function USING btree (microbe_gene_to_function_map_id);
