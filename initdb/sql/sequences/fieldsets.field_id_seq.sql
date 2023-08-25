CREATE SEQUENCE fieldsets.field_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1000
	CACHE 1
	NO CYCLE;

ALTER TABLE fieldsets.fields
ALTER COLUMN id SET DEFAULT nextval('fieldsets.field_id_seq');