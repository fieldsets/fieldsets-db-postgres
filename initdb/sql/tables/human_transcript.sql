-- public.human_transcript definition

-- Drop table

-- DROP TABLE public.human_transcript;

CREATE TABLE public.human_transcript (
	human_transcript_id serial4 NOT NULL,
	human_transcript_name varchar NOT NULL,
	human_gene_catalog_id int4 NOT NULL,
	human_gene_id int4 NOT NULL,
	source_transcript_id varchar(60) NOT NULL,
	human_transcript_source varchar(50) NOT NULL,
	human_transcript_version varchar(50) NULL,
	human_transcript_biotype varchar(50) NOT NULL,
	reference_database varchar NOT NULL,
	seqid varchar(30) NULL,
	strand varchar(1) NULL,
	human_transcript_start int4 NULL,
	human_transcript_end int4 NULL,
	tag varchar(50) NULL,
	human_transcript_support_level varchar(50) NULL,
	ccds_id varchar(200) NULL
);
