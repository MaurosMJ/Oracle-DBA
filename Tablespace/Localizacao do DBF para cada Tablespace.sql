--Author: MaurosMJ

SELECT
    tablespace_name        "Tablespace",
    file_name              "Filename",
    bytes / 1024 / 1024    "Size MB",
    maxbytes / 1024 / 1024 "Maximum Size MB",
    autoextensible         "Autoextensible"
FROM
    sys.dba_data_files
WHERE
    ( :tablespace_name IS NULL
      OR instr(lower(tablespace_name),
               lower(:tablespace_name)) > 0 )
ORDER BY
    1,
    2;