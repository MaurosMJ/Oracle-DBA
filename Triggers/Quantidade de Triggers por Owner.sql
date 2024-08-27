--Author: MaurosMJ

SELECT
    owner                                 "Owner",
    COUNT(*)                              "Trigger_Count",
    COUNT(DISTINCT table_owner
                   || '.'
                   || table_name)                        "Table_Count",
    SUM(decode(status, 'ENABLED', 1, 0))  "Number_Enabled",
    SUM(decode(status, 'DISABLED', 1, 0)) "Number_Disabled"
FROM
    sys.dba_triggers
WHERE
    ( :owner IS NULL
      OR owner LIKE upper(:owner) )
    AND substr(table_name, 1, 4) != 'BIN$'
    AND substr(table_name, 1, 3) != 'DR$'
GROUP BY
    owner;