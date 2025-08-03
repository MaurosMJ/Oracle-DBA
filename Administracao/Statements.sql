-- Determinar se uma instância é parte de um Banco de dados RAC (NO = Instância única)
SELECT PARALLEL FROM V$INSTANCE;

-- Determinar se o banco de dados está protegido contra perda de dados por um banco de dados Standby (UNPROTECTED = BD desprotegido)
SELECT PROTECTION_LEVEL FROM V$DATABASE;

-- Determinar se o recurso Streams foi configurado no banco de dados (Resultset vazio = Não configurado)
SELECT * FROM DBA_STREAMS_ADMINISTRATOR;

-- Mostrar tamanho min, max e atual dos componentes da SGA que podem ser redimencionados (Em MB)
SELECT 
    COMPONENT,
    ROUND(CURRENT_SIZE / 1024 / 1024, 2) AS CURRENT_SIZE_MB,
    ROUND(MIN_SIZE / 1024 / 1024, 2) AS MIN_SIZE_MB,
    ROUND(MAX_SIZE / 1024 / 1024, 2) AS MAX_SIZE_MB
FROM 
    V$SGA_DYNAMIC_COMPONENTS;

-- Determinar a quantidade de memória que foi alocado e está atualmente alocada para as áreas globais do sistema (Maximo já usado e atualmente em uso)
SELECT 
    NAME, 
    ROUND(VALUE / 1024 / 1024, 2) AS VALUE_MB
FROM 
    V$PGASTAT
WHERE 
    NAME IN ('maximum PGA allocated', 'total PGA allocated');

-- Gravar no disco todas as alterações que estão na memória (buffers da SGA) e que ainda não foram escritas nos datafiles. Ele sincroniza os datafiles com o conteúdo atualizado dos buffers (Pode gerar IO Intenso e alto consumo de CPU)
ALTER SYSTEM CHECKPOINT;
