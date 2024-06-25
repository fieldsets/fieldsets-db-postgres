/**
 * cron.async: Run as a one time cron job. Schedule job, execute and unschedule the job.
 * @param TEXT: cron_token
 * @param TEXT: cron_interval
 * @param TEXT: cron_sql
 **/
CREATE OR REPLACE PROCEDURE cron.async(cron_token TEXT, cron_interval TEXT, cron_sql TEXT) AS $procedure$
  DECLARE
    cron_jobid BIGINT;
    await_jobid BIGINT;
    sql_stmt TEXT;
    await_token TEXT;
  BEGIN
    SELECT cron.schedule(cron_token, cron_interval, cron_sql) INTO cron_jobid;
    await_token := format('cron_await_%s',cron_jobid::TEXT);
    sql_stmt := format('CALL cron.await(%s);',cron_jobid::TEXT);
    SELECT cron.schedule(await_token, '2 seconds', sql_stmt) INTO await_jobid;
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE cron.async (TEXT,TEXT,TEXT) IS
'/**
 * cron.async: Run as a one time cron job. Schedule job, execute and unschedule the job.
 * @param TEXT: cron_token
 * @param TEXT: cron_interval
 * @param TEXT: cron_sql
 **/';