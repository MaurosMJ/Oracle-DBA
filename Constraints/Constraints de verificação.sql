--@Author: MaurosMJ

                         select c.owner             "Owner", 

                                         c.table_name        "Table_Name", 

                                         c.constraint_name   "Constraint_Name", 

                                         initcap(c.status)   "Status", 

                                         c.search_condition  "Check Constraint", 

                                         c.owner       sdev_link_owner, 

                                         c.table_name  sdev_link_name, 

                                         'TABLE'       sdev_link_type 

                                    from sys.dba_constraints c 

                                   where (:OWNER is null or c.owner LIKE upper(:OWNER)) 

                                     and c.constraint_type = 'C' 

                                     and substr(c.table_name,1,4) != 'BIN$'  

                                     and substr(c.table_name,1,3) != 'DR$' 

                                     and (:TABLE_NAME is null or  

                                          upper(c.table_name) LIKE upper(:TABLE_NAME))  

                                   order by c.owner, c.table_name, c.constraint_name 