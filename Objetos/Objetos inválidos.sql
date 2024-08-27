--@Author: MaurosMJ

SELECT
    owner                "Owner",
    initcap(object_type) "Object_Type",
    object_name          "Object_Name",
    owner                sdev_link_owner,
    object_name          sdev_link_name,
    object_type          sdev_link_type
FROM
    sys.all_objects
WHERE
        status = 'INVALID'
    AND substr(object_name, 1, 4) != 'BIN$'
    AND substr(object_name, 1, 3) != 'DR$'
    AND ( :owner IS NULL
          OR upper(owner) LIKE upper(:owner) )
ORDER BY
    owner,
    object_type,
    object_name;