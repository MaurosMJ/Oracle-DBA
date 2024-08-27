--@Author: MaurosMJ

select  

  S.OWNER, 

  s.tablespace_name "Name", 

  count(s.bytes) "Tables",  

  sum(s.bytes/1024/1024) "Segment Usage", 

  (select ((sum(bytes))/1024/1024) from dba_ts_quotas where tablespace_name = s.tablespace_name and username = s.owner ) "Quota Usage", 

  (select (case when max_bytes = -1 then 'UNLIMITED' else to_char(max_bytes/1024/1024)||' Mb' end) "Quota" from dba_ts_quotas where tablespace_name = s.tablespace_name and username = s.owner) Quota 

from dba_segments s 

where s.segment_type = 'TABLE' 

group by S.OWNER,s.tablespace_name