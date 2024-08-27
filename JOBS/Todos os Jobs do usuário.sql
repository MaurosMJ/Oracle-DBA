--@Author: MaurosMJ

SELECT
    job         "Job",
    log_user    "Log_user",
    priv_user   "Privilege_User",
    schema_user "Schema_User",
    last_date   "Last_Date",
    this_date   "This_Date",
    next_date   "Next_Date",
    total_time  "Total_Time",
    broken      "Broken",
    INTERVAL    "Interval",
    failures    "Failures",
    what        "What"
FROM
    user_jobs
ORDER BY
    log_user,
    job;