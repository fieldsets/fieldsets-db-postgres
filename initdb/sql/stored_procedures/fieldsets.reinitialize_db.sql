/**
 * reinitialize_db: Remove schema, generated partitions, foreign tables and data
 * WARNING: This script will wipe all data & tables!
 * This script is for development purposes and avoids re-importing pipeline.imports which can be time consuming.
 * This script will wipe all table partitions, data and reset id sequences so data importing can be re-run from scratch.
 **/
CREATE OR REPLACE PROCEDURE fieldsets.reinitialize_db() AS $procedure$
DECLARE
	generated_tables RECORD;
	partition_tables RECORD;
	foreign_tables RECORD;
	sql_stmt TEXT;
	auth_string TEXT;
	clickhouse_sql_stmt TEXT;
BEGIN
	SELECT fieldsets.get_clickhouse_auth_string() INTO auth_string;
	FOR partition_tables IN
		SELECT
			parent.relname      AS parent,
    		child.relname       AS table
		FROM pg_inherits
    		JOIN pg_class parent            ON pg_inherits.inhparent = parent.oid
    		JOIN pg_class child             ON pg_inherits.inhrelid   = child.oid
    		JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
    		JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
		WHERE nmsp_parent.nspname = 'fieldsets' AND child.relispartition = TRUE AND (child.relkind = 'p' OR child.relkind = 'r')
		ORDER BY parent
	LOOP
		sql_stmt := format('ALTER TABLE %s DETACH PARTITION %s;', partition_tables.parent, partition_tables.table);
		EXECUTE sql_stmt;
	END LOOP;

	FOR foreign_tables IN
		SELECT table_name AS table from information_schema.tables WHERE table_type = 'FOREIGN' AND table_name <> 'enums'
	LOOP
		sql_stmt := format('DROP FOREIGN TABLE fieldsets.%I;', foreign_tables.table);
		EXECUTE sql_stmt;
	END LOOP;

	FOR generated_tables IN
		SELECT
  			tablename AS table
		FROM
  			pg_tables
		WHERE schemaname = 'fieldsets'
			AND (
				(tablename LIKE '__fieldsets_%') OR
				(tablename LIKE '%_lookup') OR
				(tablename LIKE '%_filter') OR
				(tablename LIKE '%_record') OR
				(tablename LIKE '%_document')
			)
	LOOP
		BEGIN
			sql_stmt := format('DROP TABLE fieldsets.%I;', generated_tables.table);
			RAISE NOTICE '%', sql_stmt;
			EXECUTE sql_stmt;
		EXCEPTION WHEN undefined_table THEN
			CONTINUE;
		END;
	END LOOP;

	DELETE FROM fieldsets.fieldsets WHERE id >= 1000;
	DELETE FROM fieldsets.fields WHERE id >= 100;
	DELETE FROM fieldsets.sets WHERE id >= 100;
	DELETE FROM fieldsets.tokens WHERE id >= 100;
	clickhouse_sql_stmt := 'DELETE FROM fieldsets.enums WHERE id > 0';
	sql_stmt := format('SELECT clickhousedb_raw_query(%L,%L);', clickhouse_sql_stmt, auth_string);
    EXECUTE sql_stmt;
   	UPDATE pipeline.imports SET imported = FALSE;
   	PERFORM setval('fieldsets.set_id_seq', 100, false);
	PERFORM setval('fieldsets.field_id_seq', 100, false);
	PERFORM setval('fieldsets.fieldset_id_seq', 1000, false);
END
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE fieldsets.reinitialize_db() IS
'/**
 * reinitialize_db: Remove schema, generated partitions, foreign tables and data
 * WARNING: This script will wipe all data & tables!
 * This script is for development purposes and avoids re-importing pipeline.imports which can be time consuming.
 * This script will wipe all table partitions, data and reset id sequences so data importing can be re-run from scratch.
 **/';
