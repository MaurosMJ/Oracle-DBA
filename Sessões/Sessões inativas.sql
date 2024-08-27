--Author: MaurosMJ

WITH vs AS (
    SELECT
        sid,
        status,
        username,
        last_call_et,
        command,
        machine,
        osuser,
        module,
        action,
        resource_consumer_group,
        client_info,
        client_identifier,
        type,
        terminal
    FROM
        gv$session
    WHERE
        status != 'ACTIVE'
)
SELECT
    vs.sid,
    vs.username,
    CASE
        WHEN vs.status = 'ACTIVE' THEN
            last_call_et
        ELSE
            NULL
    END               AS seconds_in_wait,
    (
        SELECT
            command_name
        FROM
            v$sqlcommand
        WHERE
            command_type = vs.command
    )                 AS "Command",
    lower(vs.machine) AS machine,
    vs.machine        AS machine2,
    vs.osuser,
    lower(vs.status)  AS status,
    vs.module         AS "Module",
    vs.action         AS "Action",
    vs.resource_consumer_group,
    vs.client_info,
    vs.client_identifier
FROM
    vs
WHERE
    vs.username IS NOT NULL
    AND nvl(vs.osuser, 'x') <> 'SYSTEM'
    AND vs.type <> 'BACKGROUND'
ORDER BY
    1;