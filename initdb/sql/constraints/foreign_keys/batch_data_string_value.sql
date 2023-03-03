-- public.batch_data_string_value foreign keys
ALTER TABLE public.batch_data_string_value ADD CONSTRAINT batch_data_string_value_batch_data_id_fkey FOREIGN KEY (batch_data_id) REFERENCES public.batch_data_definition(batch_data_id);
ALTER TABLE public.batch_data_string_value ADD CONSTRAINT batch_data_string_value_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batch(batch_id);
ALTER TABLE public.batch_data_string_value ADD CONSTRAINT batch_data_string_value_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution(execution_id);