-- Identificar todos os blocos que compõem um segmento, com seus respectivos tablespaces
SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT p_nome_segmento PROMPT 'Informe o nome do segmento: '

DECLARE
    wsegment_name             VARCHAR2(250) := UPPER('&p_nome_segmento');
    wtipo_segmento            VARCHAR2(250);
    wblock_id                 NUMBER;
    wtablespace_name          VARCHAR2(250);
    wblock_size               NUMBER;
    wblock_qtd                NUMBER := 0;
    wblockoutput              VARCHAR2(30000);
    wconcatsegment            VARCHAR2(30000);
    wconcatblockid            VARCHAR2(30000);
    woffsetblock              NUMBER;
    winitial_extent           VARCHAR2(250);
    wmax_extents              VARCHAR2(250);
    wstatus                   VARCHAR2(250);
    wcontents                 VARCHAR2(250);
    wlogging                  VARCHAR2(250);
    wallocation_type          VARCHAR2(250);
    wsegment_space_management VARCHAR2(250);
    wencrypted                VARCHAR2(250);

    CURSOR c1 IS
        SELECT block_id, tablespace_name
        FROM dba_extents
        WHERE segment_name = wsegment_name;

    CURSOR c2(p_tbs_name VARCHAR2) IS
        SELECT tablespace_name,
               block_size,
               initial_extent,
               max_extents,
               DECODE(status,
                      'ONLINE', 'ONLINE (ativo para leitura e escrita)',
                      'OFFLINE', 'OFFLINE (indisponível)',
                      'READ ONLY', 'READ ONLY (somente leitura)',
                      status),
               DECODE(contents,
                      'PERMANENT', 'PERMANENT (dados permanentes)',
                      'TEMPORARY', 'TEMPORARY (dados temporários)',
                      'UNDO', 'UNDO (dados de rollback)',
                      contents),
               DECODE(logging,
                      'LOGGING', 'LOGGING (operações DML são registradas)',
                      'NOLOGGING', 'NOLOGGING (operações DML não são registradas)',
                      logging),
               DECODE(allocation_type,
                      'UNIFORM', 'UNIFORM (extents com tamanho fixo)',
                      'SYSTEM', 'SYSTEM (Oracle define os tamanhos)',
                      'USER', 'USER (usuário define tamanhos)',
                      allocation_type),
               DECODE(segment_space_management,
                      'AUTO', 'AUTO (Oracle gerencia automaticamente)',
                      'MANUAL', 'MANUAL (gerenciamento manual via freelists)',
                      segment_space_management),
               DECODE(encrypted,
                      'YES', 'YES (tablespace criptografado)',
                      'NO', 'NO (não criptografado)',
                      encrypted)
        FROM dba_tablespaces
        WHERE tablespace_name = p_tbs_name;

    PROCEDURE add_to_output(p_input IN VARCHAR2) IS
    BEGIN
        wblockoutput := wblockoutput || p_input || CHR(10);
    END;

BEGIN
    SELECT object_type
    INTO wtipo_segmento
    FROM dba_objects
    WHERE object_name = wsegment_name;

    add_to_output('*** Análise do segmento: ' || wsegment_name || ' (' || wtipo_segmento || ') ***');

    OPEN c1;
    LOOP
        FETCH c1 INTO wblock_id, wtablespace_name;
        EXIT WHEN c1%NOTFOUND;

        wblock_qtd := wblock_qtd + 1;

        wconcatsegment := wconcatsegment || wblock_id || ' (' || wtablespace_name || ')' || CHR(10);

        OPEN c2(wtablespace_name);
        FETCH c2 INTO
            wtablespace_name,
            wblock_size,
            winitial_extent,
            wmax_extents,
            wstatus,
            wcontents,
            wlogging,
            wallocation_type,
            wsegment_space_management,
            wencrypted;
        CLOSE c2;

        IF wblock_size IS NOT NULL THEN
            wconcatblockid := wconcatblockid || CHR(10) ||
                              '### Bloco ' || wblock_id || ' ###' || CHR(10) ||

                              ' └Offset dentro do datafile (Posição que do extent inicia): ' ||
                              TO_CHAR(wblock_size * wblock_id / 1024 / 1024, '999999.99') || CHR(10) ||

                              ' └Tablespace: ' || wtablespace_name || CHR(10) ||

                              ' └Tamanho do bloco: ' || wblock_size || ' (' ||
                              wblock_size / 1024 || 'K)' || CHR(10) ||

                              ' └Alocação mínima de espaço do extent: ' || winitial_extent || ' (' ||
                              winitial_extent / 1024 || 'K)' || CHR(10) ||

                              ' └Número máximo do extento permitido: ' || wmax_extents || ' (' ||
                              TRUNC(wmax_extents / 1024 / 1024, 2) || 'M|' ||
                              TRUNC(wmax_extents / 1024 / 1024 / 1024, 2) || 'G)' || CHR(10) ||

                              ' └Estado atual: ' || wstatus || CHR(10) ||

                              ' └Conteúdo: ' || wcontents || CHR(10) ||

                              ' └Logging: ' || wlogging || CHR(10) ||

                              ' └Tipo de alocação: ' || wallocation_type || CHR(10) ||

                              ' └Gerenciamento de espaço de segmentos: ' || wsegment_space_management || CHR(10) ||

                              ' └Criptografia: ' || wencrypted || CHR(10);
        END IF;
    END LOOP;
    CLOSE c1;

    add_to_output('Quantidade de blocos: ' || wblock_qtd);
    add_to_output('Identificador dos blocos e tablespace:' || CHR(10) || wconcatsegment);
    add_to_output(wconcatblockid);

    DBMS_OUTPUT.PUT_LINE(wblockoutput);
END;
