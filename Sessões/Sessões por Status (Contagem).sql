--Author: MaurosMJ

SELECT
    status                 "Status",
    COUNT(DISTINCT osuser) "Distinct_OS_Users",
    type                   "Type",
    COUNT(*)               "Count"
FROM
    gv$session
GROUP BY
    status,
    type
ORDER BY
    1;