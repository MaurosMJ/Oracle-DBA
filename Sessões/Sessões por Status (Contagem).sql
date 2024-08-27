--Author: MaurosMJ

                      select status "Status", 

                                      count(distinct osuser) "Distinct_OS_Users", 

                                      type "Type",count(*) "Count" 

                                 from gv$session 

                                group by status,type 

                                order by 1 