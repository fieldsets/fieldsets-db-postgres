-- public.microbe_gene_sequence definition

-- Drop table

-- DROP TABLE public.microbe_gene_sequence;

CREATE TABLE public.microbe_gene_sequence (
	microbe_gene_sequence_id serial4 NOT NULL,
	gene_id int4 NOT NULL,
	sequence_name varchar NOT NULL
);
