--Author: MaurosMJ

                      select TABLESPACE_NAME "Tablespace", 

                                      STATUS "Status" 

                                 from sys.dba_tablespaces 

                                where status = 'OFFLINE' 

                                  and (:TABLESPACE_NAME is null or  

                                       instr(lower(tablespace_name),lower(:TABLESPACE_NAME)) > 0) 

                                order by 1 