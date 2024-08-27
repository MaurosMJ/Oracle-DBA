--Author: MaurosMJ

/* Scheduler Reports All Jobs */SELECT
    *
FROM
    "SYS"."ALL_SCHEDULER_JOBS"
WHERE
    :job_name IS NULL
    OR upper(job_name) LIKE upper(:job_name);