--@Author: MaurosMJ

SELECT
    owner        "Owner",
    trigger_name,
    trigger_type,
    table_owner,
    table_name,
    column_name,
    triggering_event,
    status,
    owner        sdev_link_owner,
    trigger_name sdev_link_name,
    'TRIGGER'    sdev_link_type
FROM
    sys.dba_triggers
WHERE
    ( :owner IS NULL
      OR owner LIKE upper(:owner) )
    AND substr(table_name, 1, 4) != 'BIN$'
    AND substr(table_name, 1, 3) != 'DR$'
    AND ( :table_name IS NULL
          OR upper(table_name) LIKE upper(:table_name) )
ORDER BY
    owner,
    trigger_name;