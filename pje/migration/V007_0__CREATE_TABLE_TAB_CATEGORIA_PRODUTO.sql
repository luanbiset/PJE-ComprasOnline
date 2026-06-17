/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade CIDADE
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
               AND table_name = 'TAB_CATEGORIA_PRODUTO'
        ),
        'SELECT ''Tabela TAB_CATEGORIA_PRODUTO já existe''',
        'CREATE TABLE TAB_CATEGORIA_PRODUTO (
            IDT_CATEGORIA_PRODUTO BIGINT NOT NULL AUTO_INCREMENT 					 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela CATEGORIA_PRODUTO.'',
			DES_CATEGORIA VARCHAR(100)												 COMMENT ''[NOT_SECURITY_APPLY] - Descrição da categoria do produto.'',
			FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1					 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se é o e-mail ativo do cliente. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT CATPRO_PK PRIMARY KEY (IDT_CATEGORIA_PRODUTO),
            CONSTRAINT CATPRO_UK01 UNIQUE (DES_CATEGORIA),
			CONSTRAINT CATPRO_CK01 CHECK (FLG_ATIVO IN (0,1))
        ) COMMENT = ''[NOT_SECURITY_APPLY] - Tabela responsável por armazenar o telefone dos clientes.'''
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
               AND table_name = 'TAB_CATEGORIA_PRODUTO'
			   AND index_name = 'CATPRO_IDX01'
        ),
        'SELECT ''Índice CATPRO_IDX01 já existe''',
        'CREATE INDEX CATPRO_IDX01 ON TAB_CATEGORIA_PRODUTO(FLG_ATIVO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_CATEGORIA_PRODUTO (DES_CATEGORIA,FLG_ATIVO,DAT_CRIACAO,DAT_ATUALIZACAO,USR_CRIACAO,USR_ALTERACAO) VALUES ('Games',1,'2026-06-17 01:47:13','2026-06-17 01:47:13',1,NULL);
