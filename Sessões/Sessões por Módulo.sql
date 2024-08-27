--@Author: MaurosMJ

SELECT
    nvl(module, 'Unidentified') "Module",
    COUNT(*)                    "Session_Count"
FROM
    gv$session
GROUP BY
    nvl(module, 'Unidentified')
ORDER BY
    1;