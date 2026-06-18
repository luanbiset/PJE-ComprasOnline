/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade TELEFONE_CLIENTE
-- DATA :        16/06/2026
-- SISTEMA:      PJE - Compras On-line
-- AUTOR:        Luan Biset
---------------------------------------------------------------------------------------------------
*/

USE pje_adm;

SET @sql := 
(
    SELECT IF(
        EXISTS (
            SELECT 1
              FROM information_schema.tables
             WHERE table_schema = DATABASE()
               AND table_name = 'TAB_TELEFONE_CLIENTE'
        ),
        'SELECT ''Tabela TAB_TELEFONE_CLIENTE já existe''',
        'CREATE TABLE TAB_TELEFONE_CLIENTE (
            IDT_TELEFONE_CLIENTE BIGINT NOT NULL AUTO_INCREMENT 					 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela TELEFONE_CLIENTE.'',
			IDT_CLIENTE BIGINT NOT NULL 											 COMMENT ''[NOT_SECURITY_APPLY] - FK para a tabela CLIENTE.'',
			COD_DDD CHAR(3) NOT NULL								 				 COMMENT ''[PII] - DDD do telefone do cliente.'',
			NUM_TELEFONE VARCHAR(20) NOT NULL 							 		 	 COMMENT ''[PII] - Número de telefone do cliente.'',
			TP_TELEFONE TINYINT NOT NULL											 COMMENT ''[PII] - Tipo do telefone do cliente. Aceita os valores (1) Fixo, (2) Celular, (3) Whatsapp, (4) Comercial.'',
			FLG_PRINCIPAL TINYINT(1) NOT NULL DEFAULT 1					 	 		 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se é principal telefone do cliente. Aceita os valores (1) Principal (0) Não principal.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT TELCLI_PK PRIMARY KEY (IDT_TELEFONE_CLIENTE),
            CONSTRAINT TELCLI_FK01 FOREIGN KEY (IDT_CLIENTE) REFERENCES TAB_CLIENTE (IDT_CLIENTE),
			CONSTRAINT TELCLI_UK01 UNIQUE (IDT_CLIENTE,COD_DDD, NUM_TELEFONE),
			CONSTRAINT TELCLI_CK01 CHECK (COD_DDD REGEXP ''^[0-9]{2,3}$'')
        ) COMMENT = ''[PII] - Tabela responsável por armazenar o telefone dos clientes.'''
    )
);


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql2 := (
    SELECT IF(
        EXISTS (
            SELECT 1
              FROM information_schema.statistics
             WHERE table_schema = DATABASE()
               AND table_name = 'TAB_TELEFONE_CLIENTE'
			   AND index_name = 'TELCLI_IDX01'
        ),
        'SELECT ''Índice TELCLI_IDX01 já existe''',
        'CREATE INDEX TELCLI_IDX01 ON TAB_TELEFONE_CLIENTE(IDT_CLIENTE,FLG_PRINCIPAL,TP_TELEFONE)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
