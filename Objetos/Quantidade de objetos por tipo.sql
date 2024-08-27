--Author: MaurosMJ

SELECT
    owner                "Owner",
    initcap(object_type) "Object Type",
    COUNT(*)             "Object Count"
FROM
    sys.all_objects
WHERE
        substr(object_name, 1, 4) != 'BIN$'
    AND substr(object_name, 1, 3) != 'DR$'
    AND ( :owner IS NULL
          OR upper(owner) LIKE upper(:owner) )
GROUP BY
    owner,
    initcap(object_type);