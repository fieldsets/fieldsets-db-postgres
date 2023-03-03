-- public.human_gene definition

-- Drop table

-- DROP TABLE public.human_gene;

CREATE TABLE public.human_gene (
	human_gene_id serial4 NOT NULL,
	human_gene_catalog_id int4 NOT NULL,
	human_gene_name varchar NOT NULL,
	source_gene_id varchar(60) NOT NULL,
	human_gene_source varchar(50) NOT NULL,
	human_gene_version varchar(50) NULL,
	human_genome_version varchar(50) NULL,
	human_gene_biotype varchar(50) NOT NULL,
	reference_database varchar(50) NOT NULL,
	seqid varchar(30) NULL,
	strand varchar(1) NULL,
	human_gene_start int4 NULL,
	human_gene_end int4 NULL
);
