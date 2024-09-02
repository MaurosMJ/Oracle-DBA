--@Author: MaurosMJ

SELECT
    s.sid,
    s.serial#,
    s.username,
    s.machine,
    s.program,
    s.status,
    t.start_time,
    l.type,
    l.lmode,
    l.ctime,
    o.object_name,
    o.object_type,
    l.block
FROM
         v$lock l
    JOIN v$session     s ON l.sid = s.sid
    JOIN v$transaction t ON s.saddr = t.ses_addr
    JOIN dba_objects   o ON l.id1 = o.object_id
WHERE

/*
Filtrar Locks mesmo não bloqueando outra sessões
*/
        1 = 1
/*
Filtrar apenas as sessões bloqueando outras sessões
*/
--    AND l.block = 1
ORDER BY
    l.ctime DESC;