--@Author: MaurosMJ

SELECT
    owner,
    table_name,
    tablespace_name,
    logging,
    num_rows,
    blocks,
    empty_blocks,
    avg_row_len   average_row_length,
    cache,
    last_analyzed date_last_analyzed,
    CASE
        WHEN la > 2              THEN
            to_char(la, '99,999.9')
            || ' days ago'
        WHEN ( la * 1440 ) > 180 THEN
            to_char((la * 24), '99,999.9')
            || ' hours ago'
        ELSE
            trunc(la * 1440)
            || ' minutes ago'
    END           last_analyzed,
    partitioned,
    iot_type,
    compression,
    owner         sdev_link_owner,
    table_name    sdev_link_name,
    'TABLE'       sdev_link_type
FROM
    (
        SELECT
            owner,
            nvl(iot_name, table_name)   table_name,
            tablespace_name,
            logging,
            num_rows,
            blocks,
            empty_blocks,
            avg_row_len,
            cache,
            last_analyzed,
            ( sysdate - last_analyzed ) la,
            partitioned,
            iot_type,
            compression
        FROM
            all_tables
        WHERE
            ( :owner IS NULL
              OR owner LIKE upper(:owner) )
            AND ( :table_name IS NULL
                  OR upper(table_name) LIKE upper(:table_name) )
    )
ORDER BY
    1,
    2;