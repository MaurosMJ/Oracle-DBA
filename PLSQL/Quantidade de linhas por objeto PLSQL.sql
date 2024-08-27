--@Author: MaurosMJ

SELECT
    owner    "Owner",
    type     "Object Type",
    name     "PL/SQL Object Name",
    COUNT(*) "Lines",
    owner    sdev_link_owner,
    name     sdev_link_name,
    type     sdev_link_type
FROM
    sys.all_source
WHERE
        owner = user
    AND name NOT LIKE 'BIN$%'
GROUP BY
    owner,
    type,
    name;