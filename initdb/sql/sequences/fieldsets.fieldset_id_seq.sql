CREATE SEQUENCE fieldsets.fieldset_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1000
	CACHE 1
	NO CYCLE;

ALTER TABLE fieldsets.fieldsets
ALTER COLUMN id SET DEFAULT nextval('fieldsets.fieldset_id_seq');