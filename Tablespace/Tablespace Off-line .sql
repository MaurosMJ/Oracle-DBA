--Author: MaurosMJ

SELECT
    tablespace_name "Tablespace",
    status          "Status"
FROM
    sys.dba_tablespaces
WHERE
        status = 'OFFLINE'
    AND ( :tablespace_name IS NULL
          OR instr(lower(tablespace_name),
                   lower(:tablespace_name)) > 0 )
ORDER BY
    1;