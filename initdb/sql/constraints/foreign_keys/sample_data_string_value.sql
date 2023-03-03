-- public.sample_data_string_value foreign keys
ALTER TABLE public.sample_data_string_value ADD CONSTRAINT sample_data_string_value_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution(execution_id);
ALTER TABLE public.sample_data_string_value ADD CONSTRAINT sample_data_string_value_sample_data_id_fkey FOREIGN KEY (sample_data_id) REFERENCES public.sample_data_definition(sample_data_id);
ALTER TABLE public.sample_data_string_value ADD CONSTRAINT sample_data_string_value_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);