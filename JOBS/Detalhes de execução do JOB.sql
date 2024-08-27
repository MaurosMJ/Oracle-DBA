--@Author: MaurosMJ

/* Scheduler Reports All Job Run Details */SELECT 

    * 

FROM 

    sys.all_scheduler_job_run_details 

WHERE 

    :actual_start_date IS NULL 

    OR ( TO_DATE(:actual_start_date) < actual_start_date ) 

ORDER BY 

    log_id DESC 