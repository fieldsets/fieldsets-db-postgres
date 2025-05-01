/**
 * cron.await: Clean up async scheduled cron job
 * @param BIGINT: cron_jobid
 **/
CREATE OR REPLACE PROCEDURE cron.await(cron_jobid BIGINT) AS $procedure$
  DECLARE
    sql_stmt TEXT;
    await_token TEXT;
    job_count INT;
    await_jobid BIGINT;
    unschedule_status RECORD;
  BEGIN
    SELECT COUNT(jobid) INTO job_count FROM cron.job_run_details WHERE jobid = cron_jobid;
    IF job_count > 0 THEN
      SELECT cron.unschedule(cron_jobid) INTO unschedule_status;
      await_token := format('cron_await_%s',cron_jobid::TEXT);
      SELECT jobid INTO await_jobid FROM cron.job WHERE jobname = await_token;
      SELECT cron.unschedule(await_jobid) INTO unschedule_status;
      DELETE FROM cron.job_run_details WHERE jobid = await_jobid;
    END IF;
  END;
$procedure$ LANGUAGE plpgsql;

COMMENT ON PROCEDURE cron.await (BIGINT) IS
'/**
 * cron.await: Clean up async scheduled cron job
 * @param BIGINT: cron_jobid
 **/';