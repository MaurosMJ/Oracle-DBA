--Author: MaurosMJ

                         select owner    "Owner", 

                                         count(*) "Trigger_Count",  

                                         count(distinct table_owner||'.'||table_name) "Table_Count",  

                                         sum(decode(status,'ENABLED',1,0))            "Number_Enabled",  

                                         sum(decode(status,'DISABLED',1,0))           "Number_Disabled"  

                                    from sys.dba_triggers 

                                   where (:OWNER is null or owner LIKE upper(:OWNER)) 

                                     and substr(table_name,1,4) != 'BIN$'  

                                     and substr(table_name,1,3) != 'DR$' 

                                   group by owner 