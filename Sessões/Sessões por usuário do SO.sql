--Author: MaurosMJ

SELECT
    osuser   "OS_User",
    COUNT(*) "Count"
FROM
    gv$session
GROUP BY
    osuser
ORDER BY
    1;