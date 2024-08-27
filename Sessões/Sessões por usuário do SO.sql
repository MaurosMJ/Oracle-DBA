--Author: MaurosMJ

                      select osuser "OS_User", 

                                      count(*) "Count" 

                                 from gv$session 

                                group by osuser 

                                order by 1 