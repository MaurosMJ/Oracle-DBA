--@Author: MaurosMJ

/*
Acessível apenas pelo DBA
mas, pode ser utilizado a view user_constraints e user_cons_columns
*/


SELECT
    co.constraint_name                          AS "Nome da Constraint",
    decode(co.constraint_type, 'P', 'PRIMARY KEY (PK)', 'U', 'UNIQUE (UK)',
           'R', 'FOREIGN KEY (FK)', 'CHECK (CK)')         AS "Tipo da Constraint",
    cc.column_name                              AS "Coluna Referenciada",
    co.search_condition                         AS "Condição",
    nvl(co.r_constraint_name, 'Sem referência') AS "Constraint Referenciada",
    (
        SELECT
            table_name
        FROM
            dba_constraints
        WHERE
            constraint_name = co.r_constraint_name
    )                                           AS "Tabela Referenciada (FK)",
    nvl(co.delete_rule, 'NO ACTION')            AS "Regra de Deleção",
    cc.position                                 AS "Posição da Constraint"
FROM
         dba_constraints co
    JOIN dba_cons_columns cc ON ( co.constraint_name = cc.constraint_name )
                                 AND ( co.table_name = cc.table_name )
ORDER BY
    co.constraint_name,
    cc.position;