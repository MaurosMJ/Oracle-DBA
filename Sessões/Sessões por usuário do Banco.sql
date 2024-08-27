--@Author: MaurosMJ

SELECT
    nvl(username, 'Unidentified') "Username",
    COUNT(*)                      "Session_Count"
FROM
    gv$session
GROUP BY
    nvl(username, 'Unidentified')
ORDER BY
    1;