--@Author: MaurosMJ

                      select nvl(module,'Unidentified') "Module", 

                                      count(*) "Session_Count" 

                                 from gv$session 

                                 group by nvl(module,'Unidentified') 

                                 order by 1 