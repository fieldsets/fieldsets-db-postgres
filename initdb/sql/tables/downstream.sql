-- public.downstream definition

-- Drop table

-- DROP TABLE public.downstream;

CREATE TABLE public.downstream (
	downstream_id serial4 NOT NULL,
	analysis_id int4 NOT NULL,
	posted timestamp NOT NULL DEFAULT now()
);
