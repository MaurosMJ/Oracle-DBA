/*
- Identifica todos os blocos que compõem um segmento, com seus respectivos tablespaces
- Obtem o DDL do objeto
- Se tabela, então obtem dados sobre as colunas usadas pelo otimizador

TODO: Obter colunas e indices da tabela. E Obter da VSQLAREA quando o segmento foi utilizado e por qual sessão....
*/
SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT p_nome_segmento PROMPT 'Informe o nome do segmento: '

DECLARE
    wgetddl                   BOOLEAN := TRUE;
    wgetblock                 BOOLEAN := TRUE;
    wschema                   VARCHAR2(30) := 'SUPORTE';
    wsegment_name             VARCHAR2(128) := UPPER('&p_nome_segmento');
    
    wtipo_segmento            VARCHAR2(30);
    wblock_id                 NUMBER;
    wtablespace_name          VARCHAR2(30);
    wblock_size               NUMBER;
    wblock_qtd                NUMBER := 0;
    wblockoutput              CLOB := EMPTY_CLOB();
    wconcatsegment            VARCHAR2(5000);
    wconcatblockid            CLOB := EMPTY_CLOB();
    wobjectddl                CLOB := EMPTY_CLOB();
    wnum_rows NUMBER (38);
    wavg_row_len  NUMBER (38);
    wsample_size NUMBER (38); 
    wlast_analyzed DATE;
    wchain_stats NUMBER (38);
    wuser_stats VARCHAR2 (3);
    wtemporary VARCHAR2 (3);
    wpartitioned VARCHAR2 (3);
    woffsetblock              NUMBER;
    winitial_extent           NUMBER;
    wmax_extents              NUMBER;
    wstatus                   VARCHAR2(100);
    wcontents                 VARCHAR2(100);
    wlogging                  VARCHAR2(100);
    wallocation_type          VARCHAR2(100);
    wsegment_space_management VARCHAR2(100);
    wencrypted                VARCHAR2(50);

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
    
    PROCEDURE get_ddl (p_objectddl out varchar2) is
    begin
    SELECT DBMS_METADATA.GET_DDL(wtipo_segmento, wsegment_name, wschema) 
    into p_objectddl
    FROM DUAL;
    end;
    

BEGIN

    SELECT object_type
    INTO wtipo_segmento
    FROM dba_objects
    WHERE object_name = wsegment_name
      AND owner = UPPER(wschema);


    add_to_output('*** Análise do segmento: ' || wsegment_name || ' (' || wtipo_segmento || ') ***' || chr(10));

if (wtipo_segmento = 'TABLE') then
    SELECT num_rows, avg_row_len, sample_size, last_analyzed, chain_cnt, decode(user_stats, 'YES', 'SIM', 'NÃO'), decode(temporary, 'Y', 'SIM', 'NÃO'), decode(partitioned, 'YES', 'SIM', 'NÃO')
    INTO wnum_rows, wavg_row_len, wsample_size, wlast_analyzed, wchain_stats, wuser_stats, wtemporary, wpartitioned
    FROM dba_tables
    WHERE table_name = wsegment_name
      AND owner = UPPER(wschema);
      
    add_to_output('### Informações sobre a tabela ###');
    add_to_output('A tabela contém: ' || wnum_rows || ' linhas. Última coleta de estatísticas da tabela: ' || to_char(wLAST_ANALYZED, 'dd/mm/rrrr hh24:MI:ss'));
    add_to_output('Tamanho médio das linhas: ' || wavg_row_len || ' (B).');
    add_to_output('Tamanho da amostra usada para coletar estatísticas: ' || wsample_size || '.');
    add_to_output('Quantidade de linhas encadeadas (chained rows): ' || wchain_stats || '.');
    add_to_output('Estatisticas definidas manualmente: ' || wuser_stats || '.');
    add_to_output('Tabela temporária: ' || wtemporary || '.');
    add_to_output('Tabela particionada: ' || wpartitioned || '.' || chr(10));
end if;

if (wgetblock) then
add_to_output('### Informações sobre os blocos que compõem o segmento: ' || wsegment_name ||' ###');
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
    end if;
    
    if (wgetddl) then
    get_ddl(wobjectddl);
    add_to_output('### DDL do objeto ### ' || chr(10) || wobjectddl);
    end if;

    FOR i IN 0 .. FLOOR(DBMS_LOB.GETLENGTH(wblockoutput) / 2000) LOOP
        DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(wblockoutput, 2000, 1 + i * 2000));
    END LOOP;
END;
/
