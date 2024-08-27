--@Author: MaurosMJ

select inst_id, count(case when status='ACTIVE' then 1 else null end) active,  

count(*) total from gv$session where type !='BACKGROUND' GROUP by inst_id 