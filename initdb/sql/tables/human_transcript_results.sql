-- public.human_transcript_results definition

-- Drop table

-- DROP TABLE public.human_transcript_results;

CREATE TABLE public.human_transcript_results (
	analysis_id int4 NOT NULL,
	human_transcript_id int4 NOT NULL,
	readcount float8 NOT NULL,
	effective_length float8 NOT NULL
);
