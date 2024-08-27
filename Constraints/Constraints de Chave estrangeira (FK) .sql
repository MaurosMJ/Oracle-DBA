--Author: MaurosMJ

SELECT
    c.owner             "Owner",
    c.table_name        "Table_Name",
    c.constraint_name   "Constraint_Name",
    c.delete_rule       "Delete_Rule",
    d.columns,
    c.r_owner           "Owner of Related Table",
    (
        SELECT DISTINCT
            r.table_name
        FROM
            sys.dba_constraints r
        WHERE
                c.r_owner = r.owner
            AND c.r_constraint_name = r.constraint_name
    )                   "Related Table",
    c.r_constraint_name "Related Constraint",
    c.owner             sdev_link_owner,
    c.table_name        sdev_link_name,
    'TABLE'             sdev_link_type
FROM
    sys.dba_constraints c,
    (
        SELECT
            a.owner,
            a.table_name,
            a.constraint_name,
            MAX(decode(position,
                       1,
                       substr(column_name, 1, 30),
                       NULL))
            || MAX(decode(position,
                          2,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          3,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          4,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          5,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          6,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          7,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          8,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          9,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          10,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          11,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          12,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          13,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          14,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          15,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL))
            || MAX(decode(position,
                          16,
                          ', '
                          || substr(column_name, 1, 30),
                          NULL)) columns
        FROM
            sys.dba_constraints  a,
            sys.dba_cons_columns b
        WHERE
            ( :owner IS NULL
              OR a.owner LIKE upper(:owner) )
            AND a.constraint_name = b.constraint_name
            AND a.owner = b.owner
            AND a.constraint_type = 'R'
            AND substr(a.table_name, 1, 4) != 'BIN$'
            AND substr(a.table_name, 1, 3) != 'DR$'
            AND ( :table_name IS NULL
                  OR upper(a.table_name) LIKE upper(:table_name) )
        GROUP BY
            a.owner,
            a.table_name,
            a.constraint_name
    )                   d
WHERE
        c.owner = d.owner
    AND c.table_name = d.table_name
    AND c.constraint_name = d.constraint_name
ORDER BY
    c.owner,
    c.table_name,
    c.constraint_name;