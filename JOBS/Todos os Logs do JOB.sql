--Author: MaurosMJ

/* Scheduler Reports All Job Logs */SELECT
    *
FROM
    sys.all_scheduler_job_log d
WHERE
    :job_name IS NULL
    OR upper(d.job_name) LIKE upper(:job_name)
ORDER BY
    log_id DESC;