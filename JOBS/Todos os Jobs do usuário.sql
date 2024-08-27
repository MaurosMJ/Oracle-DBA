--@Author: MaurosMJ

                   select job         "Job",         

                                   log_user    "Log_user",    

                                   priv_user   "Privilege_User", 

                                   schema_user "Schema_User",    

                                   last_date   "Last_Date",   

                                   this_date   "This_Date",   

                                   next_date   "Next_Date",   

                                   total_time  "Total_Time",   

                                   broken      "Broken",      

                                   interval    "Interval", 

                                   failures    "Failures", 

                                   what        "What" 

                              from user_jobs 

                             order by log_user, job     