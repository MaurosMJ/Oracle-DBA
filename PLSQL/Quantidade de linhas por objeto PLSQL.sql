--@Author: MaurosMJ

                   select owner    "Owner", 

                                   type     "Object Type", 

                                   name     "PL/SQL Object Name", 

                                   count(*) "Lines", 

                                   owner     sdev_link_owner, 

                                   name      sdev_link_name, 

                                   type      sdev_link_type 

                              from sys.all_source 

                             where owner = user 

                               and name not like 'BIN$%' 

                             group by owner, type, name     