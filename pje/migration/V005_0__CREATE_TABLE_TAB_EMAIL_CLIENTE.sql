/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade EMAIL_CLIENTE
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
               AND table_name = 'TAB_EMAIL_CLIENTE'
        ),
        'SELECT ''Tabela TAB_EMAIL_CLIENTE já existe''',
        'CREATE TABLE TAB_EMAIL_CLIENTE (
            IDT_EMAIL_CLIENTE BIGINT NOT NULL AUTO_INCREMENT 					 	 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela CLIENTE.'',
			IDT_CLIENTE BIGINT NOT NULL								 				 COMMENT ''[NOT_SECURITY_APPLY] - FK para a tabela CLIENTE.'',
			DES_EMAIL VARCHAR(150) NOT NULL 							 		 	 COMMENT ''[PII] - Email do cliente.'',
			FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1					 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se é o e-mail ativo do cliente. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT EMACLI_PK PRIMARY KEY (IDT_EMAIL_CLIENTE),
            CONSTRAINT EMACLI_FK01 FOREIGN KEY (IDT_CLIENTE) REFERENCES TAB_CLIENTE (IDT_CLIENTE),
			CONSTRAINT EMACLI_UK01 UNIQUE (IDT_CLIENTE,DES_EMAIL)
        ) COMMENT = ''[PII] - Tabela responsável por armazenar o endereço de email dos clientes.'''
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
               AND table_name = 'TAB_EMAIL_CLIENTE'
			   AND index_name = 'EMACLI_IDX01'
        ),
        'SELECT ''Índice EMACLI_IDX01 já existe''',
        'CREATE INDEX EMACLI_IDX01 ON TAB_EMAIL_CLIENTE(FLG_ATIVO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_EMAIL_CLIENTE (IDT_CLIENTE,DES_EMAIL,FLG_ATIVO,DAT_CRIACAO,DAT_ATUALIZACAO,IDT_USR_CRIACAO,IDT_USR_ALTERACAO) VALUES (1,'teste@gmail.com',1,'2026-06-17 01:50:17','2026-06-17 01:50:17',1,NULL)
ON DUPLICATE KEY UPDATE DES_EMAIL = VALUES(DES_EMAIL);
COMMIT;
