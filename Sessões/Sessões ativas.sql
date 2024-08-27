--@Author: MaurosMJ

SELECT
    inst_id,
    COUNT(
        CASE
            WHEN status = 'ACTIVE' THEN
                1
            ELSE
                NULL
        END
    )        active,
    COUNT(*) total
FROM
    gv$session
WHERE
    type != 'BACKGROUND'
GROUP BY
    inst_id;