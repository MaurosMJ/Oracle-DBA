--@Author: MaurosMJ

SELECT
    segment_name        "Table_Name",
    tablespace_name     "Tablespace",
    bytes / 1024 / 1024 "Megabytes"
FROM
    user_segments
WHERE
        segment_type = 'TABLE'
    AND segment_name NOT LIKE 'BIN$%'
ORDER BY
    segment_name,
    tablespace_name;