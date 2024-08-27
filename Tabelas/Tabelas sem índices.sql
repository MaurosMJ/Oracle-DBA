--Author: MaurosMJ

SELECT
    *
FROM
    (
        SELECT
            owner      owner,
            table_name table_name,
            owner      sdev_link_owner,
            table_name sdev_link_name,
            'TABLE'    sdev_link_type
        FROM
            sys.dba_tables
        WHERE
            ( :owner IS NULL
              OR instr(owner,
                       upper(:owner)) > 0 )
            AND temporary = 'N'
            AND substr(table_name, 1, 4) != 'BIN$'
            AND substr(table_name, 1, 3) != 'DR$'
        MINUS
        SELECT
            owner,
            table_name,
            owner      sdev_link_owner,
            table_name sdev_link_name,
            'TABLE'    sdev_link_type
        FROM
            sys.dba_indexes
        WHERE
            ( :owner IS NULL
              OR instr(owner,
                       upper(:owner)) > 0 )
    )
ORDER BY
    owner,
    table_name;