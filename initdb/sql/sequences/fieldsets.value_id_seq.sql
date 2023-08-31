CREATE SEQUENCE fieldsets.value_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER TABLE fieldsets.values
ALTER COLUMN id SET DEFAULT nextval('fieldsets.value_id_seq');