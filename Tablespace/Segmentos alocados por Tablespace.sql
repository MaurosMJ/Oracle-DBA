--Author: MaurosMJ

SELECT
    owner               "Owner",
    tablespace_name     "Tablespace",
    segment_name        "Segment",
    extents             "Extents",
    bytes / 1024 / 1024 "Megabytes"
FROM
    sys.dba_segments
WHERE
        upper(substr(segment_name, 1, 4)) != 'BIN$'
    AND upper(substr(segment_name, 1, 3)) != 'DR$'
    AND ( :tablespace_name IS NULL
          OR instr(lower(tablespace_name),
                   lower(:tablespace_name)) > 0 )
ORDER BY
    owner,
    extents DESC,
    tablespace_name,
    segment_name;