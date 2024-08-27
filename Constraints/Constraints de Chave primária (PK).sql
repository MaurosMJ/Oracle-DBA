--Author: MaurosMJ

SELECT
    ac.owner           "Owner",
    ac.table_name      "Table_Name",
    ac.constraint_name "Constraint_Name",
    initcap(ac.status) "Status",
    (
        SELECT
            MAX(decode(column_position, 1, column_name))
            || MAX(decode(column_position, 2, ', ' || column_name))
            || MAX(decode(column_position, 3, ', ' || column_name))
            || MAX(decode(column_position, 4, ', ' || column_name))
            || MAX(decode(column_position, 5, ', ' || column_name))
            || MAX(decode(column_position, 6, ', ' || column_name))
            || MAX(decode(column_position, 7, ', ' || column_name))
            || MAX(decode(column_position, 8, ', ' || column_name))
            || MAX(decode(column_position, 9, ', ' || column_name))
            || MAX(decode(column_position, 10, ', ' || column_name)) columns
        FROM
            sys.dba_ind_columns dc,
            sys.dba_indexes     di
        WHERE
            ( :owner IS NULL
              OR instr(dc.table_owner,
                       upper(:owner)) > 0 )
            AND dc.table_name = ac.table_name
            AND dc.index_name = di.index_name
            AND dc.index_name = ac.constraint_name
            AND dc.index_owner = di.owner
    )                  "Primary Key Columns",
    ac.owner           sdev_link_owner,
    ac.table_name      sdev_link_name,
    'TABLE'            sdev_link_type
FROM
    sys.dba_constraints ac
WHERE
    ( :owner IS NULL
      OR ac.owner LIKE upper(:owner) )
    AND ac.constraint_type = 'P'
    AND substr(ac.table_name, 1, 4) != 'BIN$'
    AND substr(ac.table_name, 1, 3) != 'DR$'
    AND ( :table_name IS NULL
          OR upper(ac.table_name) LIKE upper(:table_name) )
ORDER BY
    ac.owner,
    ac.table_name,
    ac.constraint_name;