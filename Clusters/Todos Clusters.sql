--@Author: MaurosMJ

SELECT
    owner,
    cluster_name,
    tablespace_name
FROM
    sys.dba_clusters
WHERE
    cluster_name NOT LIKE 'BIN$%'
    AND owner NOT IN ( 'SYS', 'SYSTEM' )
ORDER BY
    1,
    2;