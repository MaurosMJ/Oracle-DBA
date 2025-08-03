-- Determinar se uma instância é parte de um Banco de dados RAC (NO = Instância única)
SELECT PARALLEL FROM V$INSTANCE;

-- Determinar se o banco de dados está protegido contra perda de dados por um banco de dados Standby (UNPROTECTED = BD desprotegido)
SELECT PROTECTION_LEVEL FROM V$DATABASE;

-- Determinar se o recurso Streams foi configurado no banco de dados (Resultset vazio = Não configurado)
SELECT * FROM DBA_STREAMS_ADMINISTRATOR;
