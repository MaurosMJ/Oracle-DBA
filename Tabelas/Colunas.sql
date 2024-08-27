--@Author: MaurosMJ

                         select owner       "Owner", 

                                         table_name  "Table_Name", 

                                         column_name "Column_Name", 

                                         initcap(data_type) || 

                                            decode(data_type,   

                                                   'CHAR',      '('|| char_length ||')', 

                                                   'VARCHAR',   '('|| char_length ||')', 

                                                   'VARCHAR2',  '('|| char_length ||')', 

                                                   'NCHAR',     '('|| char_length ||')',          

                                                   'NVARCHAR',  '('|| char_length ||')',   

                                                   'NVARCHAR2', '('|| char_length ||')',  

                                                   'NUMBER',    '('|| 

                                                    nvl(data_precision,data_length)|| 

                                                        decode(data_scale,null,null, 

                                                               ','||data_scale)||')', 

                                                      null) "Type", 

                                         nullable "Nullable", 

                                         owner       sdev_link_owner, 

                                         table_name  sdev_link_name, 

                                         'TABLE'     sdev_link_type 

                                    from sys.dba_tab_columns 

                                   where (:OWNER is null or owner LIKE upper(:OWNER)) 

                                     and (:TABLE_NAME is null or  

                                          upper(table_name) LIKE upper(:TABLE_NAME)) 

                                     and (:COLUMN_NAME is null or  

                                          upper(column_name) LIKE upper(:COLUMN_NAME)) 

                                     and substr(table_name,1,4) != 'BIN$' 

                                     and substr(table_name,1,3) != 'DR$' 

                                   order by owner, table_name, column_id 