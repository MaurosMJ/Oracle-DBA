--@Author: MaurosMJ

SELECT
    substr(sql_text, 1, 500)   "SQL",
    ( cpu_time / 1000000 )     "CPU_Seconds",
    disk_reads                 "Disk_Reads",
    buffer_gets                "Buffer_Gets",
    executions                 "Executions",
    CASE
        WHEN rows_processed = 0 THEN
            NULL
        ELSE
            round((buffer_gets / nvl(replace(rows_processed, 0, 1),
                                     1)))
    END                        "Buffer_gets/rows_proc",
    round((buffer_gets / nvl(replace(executions, 0, 1),
                             1)))                       "Buffer_gets/executions",
    ( elapsed_time / 1000000 ) "Elapsed_Seconds",
    module                     "Module"
FROM
    gv$sql s
ORDER BY
    cpu_time DESC NULLS LAST;