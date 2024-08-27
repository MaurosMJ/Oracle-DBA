--@Author: MaurosMJ

                    select owner "Owner",  

                                   name  "PL/SQL Object Name", 

                                   type  "Type", 

                                   line  "Line", 

                                   text  "Text", 

                                   owner  sdev_link_owner, 

                                   name   sdev_link_name, 

                                   type   sdev_link_type, 

   line   sdev_link_line  

                              from sys.all_source 

                             where owner = user 

                               and (:OBJECT_NAME is null or  

                                    upper(name) LIKE upper(:OBJECT_NAME)) 

                               and (:TEXT_STRING is null or  

                                    upper(text) LIKE upper(:TEXT_STRING)) 

                               and name not like 'BIN$%' 

                             order by owner, name, type, line     