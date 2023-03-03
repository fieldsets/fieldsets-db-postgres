ALTER TABLE public.sample ADD CONSTRAINT sample_flowcell_id_batch_id_plate_position_key UNIQUE (flowcell_id, batch_id, plate_position);
ALTER TABLE public.sample ADD CONSTRAINT sample_flowcell_id_batch_id_sample_name_plate_position_key UNIQUE (flowcell_id, batch_id, sample_name, plate_position);
ALTER TABLE public.sample ADD CONSTRAINT sample_pkey PRIMARY KEY (sample_id);
