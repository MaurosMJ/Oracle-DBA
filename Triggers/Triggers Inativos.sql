--@Author: MaurosMJ

                         select owner "Owner", 

                                         trigger_name,  

                                         trigger_type,  

                                         table_owner,  

                                         table_name,  

                                         column_Name,  

                                         triggering_event, 

                                         owner         sdev_link_owner, 

                                         trigger_name  sdev_link_name, 

                                         'TRIGGER'     sdev_link_type 

                                    from sys.dba_triggers 

                                   where (:OWNER is null or owner LIKE upper(:OWNER)) 

                                     and substr(table_name,1,4) != 'BIN$'  

                                     and substr(table_name,1,3) != 'DR$' 

                                     and status = 'DISABLED' 

                                     and (:TABLE_NAME is null or  

                                         upper(table_name) LIKE upper(:TABLE_NAME))  

                                   order by owner, trigger_name 