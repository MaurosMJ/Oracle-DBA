--Author: MaurosMJ

                         select ac.owner            "Owner", 

                                         ac.table_name       "Table_Name", 

                                         ac.constraint_name  "Constraint_Name", 

                                         initcap(ac.status)  "Status", 

                                         (select max(decode(column_position,1 ,column_name))|| 

                                                 max(decode(column_position,2 ,', '||column_name))|| 

                                                 max(decode(column_position,3 ,', '||column_name))|| 

                                                 max(decode(column_position,4 ,', '||column_name))|| 

                                                 max(decode(column_position,5 ,', '||column_name))|| 

                                                 max(decode(column_position,6 ,', '||column_name))|| 

                                                 max(decode(column_position,7 ,', '||column_name))|| 

                                                 max(decode(column_position,8 ,', '||column_name))|| 

                                                 max(decode(column_position,9 ,', '||column_name))|| 

                                                 max(decode(column_position,10,', '||column_name)) 

                                                 columns 

                                           from sys.dba_ind_columns dc, 

                                                sys.dba_indexes di 

                                          where (:OWNER is null or instr(dc.table_owner, upper(:OWNER))>0) 

                                            and dc.table_name  = ac.table_name 

                                            and dc.index_name  = di.index_name 

                                            and dc.index_name  = ac.constraint_name 

                                            and dc.index_owner = di.owner 

                                        ) "Primary Key Columns", 

                                         ac.owner       sdev_link_owner, 

                                         ac.table_name  sdev_link_name, 

                                         'TABLE'     sdev_link_type 

                                   from sys.dba_constraints ac 

                                  where (:OWNER is null or ac.owner LIKE upper(:OWNER)) 

                                    and ac.constraint_type = 'P' 

                                    and substr(ac.table_name,1,4) != 'BIN$'  

                                    and substr(ac.table_name,1,3) != 'DR$' 

                                    and (:TABLE_NAME is null or  

                                         upper(ac.table_name) LIKE upper(:TABLE_NAME))  

                                  order by ac.owner, ac.table_name, ac.constraint_name 