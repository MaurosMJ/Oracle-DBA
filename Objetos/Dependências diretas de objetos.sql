--Author: MaurosMJ

SELECT
    owner                "Owner",
    name                 "Name",
    type                 "Type",
    referenced_owner     "Referenced_Owner",
    referenced_name      "Referenced_Name",
    referenced_type      "Referenced_Type",
    referenced_link_name "Referenced_Link_Name",
    dependency_type      "Dependency_Type",
    owner                sdev_link_owner,
    name                 sdev_link_name,
    type                 sdev_link_type
FROM
    sys.all_dependencies
WHERE
    ( :owner IS NULL
      OR upper(owner) LIKE upper(:owner) )
    AND substr(name, 1, 4) != 'BIN$'
    AND substr(referenced_name, 1, 4) != 'BIN$'
ORDER BY
    owner,
    name,
    referenced_owner,
    referenced_name;