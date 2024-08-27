--@Author: MaurosMJ

SELECT
    c.owner            "Owner",
    c.table_name       "Table_Name",
    c.constraint_name  "Constraint_Name",
    initcap(c.status)  "Status",
    c.search_condition "Check Constraint",
    c.owner            sdev_link_owner,
    c.table_name       sdev_link_name,
    'TABLE'            sdev_link_type
FROM
    sys.dba_constraints c
WHERE
    ( :owner IS NULL
      OR c.owner LIKE upper(:owner) )
    AND c.constraint_type = 'C'
    AND substr(c.table_name, 1, 4) != 'BIN$'
    AND substr(c.table_name, 1, 3) != 'DR$'
    AND ( :table_name IS NULL
          OR upper(c.table_name) LIKE upper(:table_name) )
ORDER BY
    c.owner,
    c.table_name,
    c.constraint_name;