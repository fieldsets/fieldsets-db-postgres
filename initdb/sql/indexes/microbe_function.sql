-- public.microbe_function index
CREATE UNIQUE INDEX microbe_function_microbe_function_catalog_id_function_name_key ON public.microbe_function USING btree (microbe_function_catalog_id, function_name, function_entry, function_definition);
