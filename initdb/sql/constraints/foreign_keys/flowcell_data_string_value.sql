-- public.flowcell_data_string_value foreign keys

ALTER TABLE public.flowcell_data_string_value ADD CONSTRAINT flowcell_data_string_value_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution(execution_id);
ALTER TABLE public.flowcell_data_string_value ADD CONSTRAINT flowcell_data_string_value_flowcell_data_id_fkey FOREIGN KEY (flowcell_data_id) REFERENCES public.flowcell_data_definition(flowcell_data_id);
ALTER TABLE public.flowcell_data_string_value ADD CONSTRAINT flowcell_data_string_value_flowcell_id_fkey FOREIGN KEY (flowcell_id) REFERENCES public.flowcell(flowcell_id);