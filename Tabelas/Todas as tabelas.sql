--@Author: MaurosMJ

              select owner, 

                                   table_name, 

                                   tablespace_name, 

                                   logging, 

                                   num_rows, 

                                   blocks, 

                                   empty_blocks, 

                                   avg_row_len average_row_length, 

                                   cache, 

                                   last_analyzed date_last_analyzed, 

                                   case when la > 2 

                                        then to_char(la,'99,999.9')||  

                                                     ' days ago' 

                                        when (la*1440) > 180 

                                        then to_char((la*24),'99,999.9')||  

                                                     ' hours ago' 

                                        else trunc(la*1440) || ' minutes ago'  

                                        end last_analyzed, 

                                   partitioned, 

                                   iot_type, 

                                   compression, 

                                   owner       sdev_link_owner, 

                                   table_name  sdev_link_name, 

                                   'TABLE'     sdev_link_type 

                              from (select owner, 

                                           nvl(iot_name,table_name) table_name, 

                                           tablespace_name, 

                                           logging, 

                                           num_rows, 

                                           blocks, 

                                           empty_blocks, 

                                           avg_row_len, 

                                           cache, 

                                           last_analyzed, 

                                           (sysdate-last_analyzed) la, 

                                           partitioned, 

                                           iot_type, 

                                           compression 

                                      from all_tables 

                                     where (:OWNER is null or owner LIKE upper(:OWNER)) 

                                       and (:TABLE_NAME is null or  

                                            upper(table_name) LIKE upper(:TABLE_NAME))) 

                             order by 1,2 