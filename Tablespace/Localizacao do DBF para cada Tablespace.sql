--Author: MaurosMJ

                      select TABLESPACE_NAME "Tablespace",   

                                      FILE_NAME "Filename",   

                                      BYTES/1024/1024 "Size MB",  

                                      MAXBYTES/1024/1024 "Maximum Size MB",  

                                      AUTOEXTENSIBLE "Autoextensible" 

                                 from SYS.DBA_DATA_FILES 

                                where (:TABLESPACE_NAME is null or  

                                       instr(lower(tablespace_name),lower(:TABLESPACE_NAME)) > 0) 

                                order by 1,2 