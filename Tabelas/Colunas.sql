--@Author: MaurosMJ

SELECT
    owner       "Owner",
    table_name  "Table_Name",
    column_name "Column_Name",
    initcap(data_type)
    || decode(data_type,
              'CHAR',
              '('
              || char_length
              || ')',
              'VARCHAR',
              '('
              || char_length
              || ')',
              'VARCHAR2',
              '('
              || char_length
              || ')',
              'NCHAR',
              '('
              || char_length
              || ')',
              'NVARCHAR',
              '('
              || char_length
              || ')',
              'NVARCHAR2',
              '('
              || char_length
              || ')',
              'NUMBER',
              '('
              || nvl(data_precision, data_length)
              || decode(data_scale, NULL, NULL, ',' || data_scale)
              || ')',
              NULL)    "Type",
    nullable    "Nullable",
    owner       sdev_link_owner,
    table_name  sdev_link_name,
    'TABLE'     sdev_link_type
FROM
    sys.dba_tab_columns
WHERE
    ( :owner IS NULL
      OR owner LIKE upper(:owner) )
    AND ( :table_name IS NULL
          OR upper(table_name) LIKE upper(:table_name) )
    AND ( :column_name IS NULL
          OR upper(column_name) LIKE upper(:column_name) )
    AND substr(table_name, 1, 4) != 'BIN$'
    AND substr(table_name, 1, 3) != 'DR$'
ORDER BY
    owner,
    table_name,
    column_id;