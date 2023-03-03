-- public.microbe_genome_sequence definition

-- Drop table

-- DROP TABLE public.microbe_genome_sequence;

CREATE TABLE public.microbe_genome_sequence (
	microbe_genome_sequence_id serial4 NOT NULL,
	genome_id int4 NOT NULL,
	sequence_name varchar NOT NULL
);
