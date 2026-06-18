/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade CLIENTE
-- DATA :        16/06/2026
-- SISTEMA:      PJE - Compras On-line
-- AUTOR:        Luan Biset
---------------------------------------------------------------------------------------------------
*/

USE pje_adm;

SET @sql := (
    SELECT IF(
        EXISTS (
            SELECT 1
              FROM information_schema.tables
             WHERE table_schema = DATABASE()
               AND table_name = 'TAB_CLIENTE'
        ),
        'SELECT ''Tabela TAB_CLIENTE já existe''',
        'CREATE TABLE TAB_CLIENTE (
            IDT_CLIENTE BIGINT NOT NULL AUTO_INCREMENT 					 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela CLIENTE.'',
			NUM_CPF VARCHAR(14) NOT NULL								 COMMENT ''[PII] - Número do CPF do cliente.'',
			NAM_CLIENTE VARCHAR(150) NOT NULL 							 COMMENT ''[PII] - Nome do cliente.'',
			DAT_NASCIMENTO DATE NOT NULL								 COMMENT ''[PII] - Data de nascimento do cliente.'',
            FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1						 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se o registro está ativo ou não. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT CLI_PK PRIMARY KEY (IDT_CLIENTE),
            CONSTRAINT CLI_UK01 UNIQUE (NUM_CPF),
			CONSTRAINT CLI_CK01 CHECK (FLG_ATIVO IN (0,1))
        ) COMMENT = ''[PII] - Tabela responsável por armazenar os clientes.'''
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
               AND table_name = 'TAB_CLIENTE'
			   AND index_name = 'CLI_IDX01'
        ),
        'SELECT ''Índice CLI_IDX01 já existe''',
        'CREATE INDEX CLI_IDX01 ON TAB_CLIENTE(NAM_CLIENTE,DAT_NASCIMENTO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_CLIENTE (NUM_CPF,NAM_CLIENTE,DAT_NASCIMENTO,FLG_ATIVO,DAT_CRIACAO,DAT_ATUALIZACAO,IDT_USR_CRIACAO,IDT_USR_ALTERACAO) 
VALUES ('01212332122','Luan Biset','1992-06-18',1,'2026-06-17 01:49:35','2026-06-17 01:49:35',1,NULL) ON DUPLICATE KEY UPDATE NAM_CLIENTE = VALUES(NAM_CLIENTE), NUM_CPF = VALUES(NUM_CPF), DAT_NASCIMENTO = VALUES(DAT_NASCIMENTO);
COMMIT;
