--@Author: MaurosMJ

SELECT
    s.owner,
    s.tablespace_name          "Name",
    COUNT(s.bytes)             "Tables",
    SUM(s.bytes / 1024 / 1024) "Segment Usage",
    (
        SELECT
            ( ( SUM(bytes) ) / 1024 / 1024 )
        FROM
            dba_ts_quotas
        WHERE
                tablespace_name = s.tablespace_name
            AND username = s.owner
    )                          "Quota Usage",
    (
        SELECT
            (
                CASE
                    WHEN max_bytes = - 1 THEN
                        'UNLIMITED'
                    ELSE
                        to_char(max_bytes / 1024 / 1024)
                        || ' Mb'
                END
            ) "Quota"
        FROM
            dba_ts_quotas
        WHERE
                tablespace_name = s.tablespace_name
            AND username = s.owner
    )                          quota
FROM
    dba_segments s
WHERE
    s.segment_type = 'TABLE'
GROUP BY
    s.owner,
    s.tablespace_name;