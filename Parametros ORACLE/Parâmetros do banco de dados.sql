--@Author: MaurosMJ

SELECT
    name                                 "Paramater_Name",
    decode(type, 1, 'Boolean', 2, 'String',
           3, 'Integer', 4, 'Parameter file', 5,
           'Reserved', 6, 'Big Integer') type,
    value                                "Value",
    isdefault                            "Default",
    isses_modifiable                     "Session_Modifiable",
    issys_modifiable                     "System_Modifiable",
    description                          "Description"
FROM
    gv$parameter
WHERE
    ( :parameter_name IS NULL
      OR instr(lower(name),
               lower(:parameter_name)) > 0 )
    AND substr(name, 1, 2) != '__'
ORDER BY
    name;