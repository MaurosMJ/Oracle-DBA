--@Author: MaurosMJ

                      select nvl(username,'Unidentified') "Username", 

                                      count(*) "Session_Count" 

                                 from gv$session 

                                group by nvl(username,'Unidentified') 

                                order by 1 