--Author: MaurosMJ

                           select c.owner            "Owner", 

                                            c.table_name       "Table_Name", 

                                            c.constraint_name  "Constraint_Name", 

                                            c.delete_rule      "Delete_Rule", 

                                            d.columns, 

                                            c.r_owner "Owner of Related Table", 

                                            (select distinct r.table_name 

                                               from sys.dba_constraints r 

                                              where c.r_owner           = r.owner 

                                                and c.r_constraint_name = r.constraint_name) "Related Table", 

                                            c.r_constraint_name "Related Constraint", 

                                         c.owner       sdev_link_owner, 

                                         c.table_name  sdev_link_name, 

                                         'TABLE'     sdev_link_type 

                                       from sys.dba_constraints c, 

                                            ( 

                                            select a.owner, 

                                                   a.table_name, 

                                                   a.constraint_name, 

                                                  max(decode(position, 1,     substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 2,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 3,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 4,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 5,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 6,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 7,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 8,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position, 9,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,10,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,11,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,12,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,13,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,14,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,15,', '||substr(column_name,1,30),NULL)) ||  

                                                  max(decode(position,16,', '||substr(column_name,1,30),NULL)) columns 

                                               from sys.dba_constraints a, 

                                                    sys.dba_cons_columns b 

                                              where (:OWNER is null or a.owner LIKE upper(:OWNER)) 

                                                and a.constraint_name = b.constraint_name 

                                                and a.owner = b.owner 

                                                and a.constraint_type = 'R' 

                                                and substr(a.table_name,1,4) != 'BIN$' 

                                                and substr(a.table_name,1,3) != 'DR$' 

                                                and (:TABLE_NAME is null or  

                                                     upper(a.table_name) LIKE upper(:TABLE_NAME)) 

                                              group by a.owner, a.table_name, a.constraint_name ) d 

                                      where c.owner           = d.owner 

                                        and c.table_name      = d.table_name 

                                        and c.constraint_name = d.constraint_name 

                                      order by c.owner, c.table_name, c.constraint_name 