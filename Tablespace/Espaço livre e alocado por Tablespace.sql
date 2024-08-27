--Author: MaurosMJ

SELECT
    nvl(b.tablespace_name,
        nvl(a.tablespace_name, 'UNKNOWN'))                    "Tablespace",
    kbytes_alloc                                              "Allocated MB",
    kbytes_alloc - nvl(kbytes_free, 0)                        "Used MB",
    nvl(kbytes_free, 0)                                       "Free MB",
    ( ( kbytes_alloc - nvl(kbytes_free, 0) ) / kbytes_alloc ) "Used",
    data_files                                                "Data Files"
FROM
    (
        SELECT
            SUM(bytes) / 1024 / 1024 kbytes_free,
            MAX(bytes) / 1024 / 1024 largest,
            tablespace_name
        FROM
            sys.dba_free_space
        GROUP BY
            tablespace_name
    ) a,
    (
        SELECT
            SUM(bytes) / 1024 / 1024 kbytes_alloc,
            tablespace_name,
            COUNT(*)                 data_files
        FROM
            sys.dba_data_files
        GROUP BY
            tablespace_name
    ) b
WHERE
        a.tablespace_name (+) = b.tablespace_name
    AND ( :tablespace_name IS NULL
          OR instr(lower(b.tablespace_name),
                   lower(:tablespace_name)) > 0 )
ORDER BY
    1;