-- public.batch foreign keys
ALTER TABLE public.batch ADD CONSTRAINT batch_flowcell_id_fkey FOREIGN KEY (flowcell_id) REFERENCES public.flowcell(flowcell_id);