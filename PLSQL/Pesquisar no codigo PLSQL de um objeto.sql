--@Author: MaurosMJ
SELECT
    owner "Owner",
    name  "PL/SQL Object Name",
    type  "Type",
    line  "Line",
    text  "Text",
    owner sdev_link_owner,
    name  sdev_link_name,
    type  sdev_link_type,
    line  sdev_link_line
FROM
    sys.all_source
WHERE
        owner = user
    AND ( :object_name IS NULL
          OR upper(name) LIKE upper(:object_name) )
    AND ( :text_string IS NULL
          OR upper(text) LIKE upper(:text_string) )
    AND name NOT LIKE 'BIN$%'
ORDER BY
    owner,
    name,
    type,
    line;