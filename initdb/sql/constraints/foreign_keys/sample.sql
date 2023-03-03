-- public.sample foreign keys
ALTER TABLE public.sample ADD CONSTRAINT sample_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);
ALTER TABLE public.sample ADD CONSTRAINT sample_flowcell_id_fkey FOREIGN KEY (flowcell_id) REFERENCES public.flowcell(flowcell_id);