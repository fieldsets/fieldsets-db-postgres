-- public.execution definition

-- Drop table

-- DROP TABLE public.execution;

CREATE TABLE public.execution (
	execution_id serial4 NOT NULL,
	execution_date timestamp NOT NULL DEFAULT now(),
	execution_name varchar NOT NULL
);