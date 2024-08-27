--@Author: MaurosMJ

                         select c.owner             "Owner", 

                                         c.table_name        "Table_Name", 

                                         c.constraint_name   "Constraint_Name", 

                                         decode(c.constraint_type,'P','Primary_Key', 

                                                                  'U','Unique', 

                                                                  'R','Foreign_Key', 

                                                                  'C','Check') "Constraint_Type", 

                                         initcap(c.status) "Status", 

                                         c.owner       sdev_link_owner, 

                                         c.table_name  sdev_link_name, 

                                         decode(c.constraint_type,'V','VIEW','TABLE')     sdev_link_type 

                                    from sys.dba_constraints c 

                                   where (:OWNER is null or upper(c.owner) like '%'||upper(:OWNER)||'%') 

                                     and substr(c.table_name,1,4) != 'BIN$'  

                                     and substr(c.table_name,1,3) != 'DR$' 

                                     and (:TABLE_NAME is null or  

                                         upper(c.table_name) LIKE upper(:TABLE_NAME))  

                                   order by c.owner, c.table_name, c.constraint_name 