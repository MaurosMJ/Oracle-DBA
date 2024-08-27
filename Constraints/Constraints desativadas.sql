--@Author: MaurosMJ

SELECT
    c.owner                                         "Owner",
    c.table_name                                    "Table_Name",
    c.constraint_name                               "Constraint_Name",
    decode(c.constraint_type, 'P', 'Primary_Key', 'U', 'Unique',
           'R', 'Foreign_Key', 'C', 'Check')        "Constraint_Type",
    c.owner                                         sdev_link_owner,
    c.table_name                                    sdev_link_name,
    decode(c.constraint_type, 'V', 'VIEW', 'TABLE') sdev_link_type
FROM
    sys.dba_constraints c
WHERE
    ( :owner IS NULL
      OR upper(c.owner) LIKE '%'
                             || upper(:owner)
                             || '%' )
    AND c.status != 'ENABLED'
    AND substr(c.table_name, 1, 4) != 'BIN$'
    AND substr(c.table_name, 1, 3) != 'DR$'
    AND ( :table_name IS NULL
          OR upper(c.table_name) LIKE upper(:table_name) )
ORDER BY
    c.owner,
    c.table_name,
    c.constraint_name;