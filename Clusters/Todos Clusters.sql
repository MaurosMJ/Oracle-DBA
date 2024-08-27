--@Author: MaurosMJ

                            select OWNER, 

                                            CLUSTER_NAME,  

                                            TABLESPACE_NAME 

                                       from sys.dba_clusters 

                                      where cluster_name not like 'BIN$%'  

                                        and owner not in ('SYS','SYSTEM') 

                                      order by 1, 2 