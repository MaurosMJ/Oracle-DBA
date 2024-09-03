--@Author: MaurosMJ

/*
Parametros de sessão persiste apenas para a sessão atual
*/

ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';

SELECT
    user                                    AS "USUÁRIO",
    to_char(sysdate, 'hh:mi:ss dd/mm/rrrr') AS "DATA",
    userenv('language')                     AS "IDIOMA DO AMBIENTE",
    uid                                     AS "UID",
    userenv('sid')                          AS "SID",
    userenv('terminal')                     AS "TERMINAL",
    userenv('instance')                     AS "INSTANCIA",
    userenv('entryid')                      AS "ENTRY ID"
FROM
    dual;