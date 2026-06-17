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
               AND table_name = 'TAB_PRODUTO'
        ),
        'SELECT ''Tabela TAB_PRODUTO já existe''',
        'CREATE TABLE TAB_PRODUTO (
            IDT_PRODUTO BIGINT NOT NULL AUTO_INCREMENT 					 			 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela PRODUTO.'',
			IDT_CATEGORIA_PRODUTO BIGINT NOT NULL									 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela CATEGORIA_PRODUTO.'',
			DES_PRODUTO VARCHAR(100) NOT NULL										 COMMENT ''[NOT_SECURITY_APPLY] - Descrição do produto.'',
			DES_IMAGEM_PROD VARCHAR(300)											 COMMENT ''[NOT_SECURITY_APPLY] - Caminho físico para a imagem do produto.'',
			VAL_PRODUTO_UNIT	DECIMAL(12,2) NOT NULL								 COMMENT ''[NOT_SECURITY_APPLY] - Preço do produto por unidade.'',
			FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1					 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se o produto está ativo. Aceita os valores (1) Ativo e ou (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT PROD_PK PRIMARY KEY (IDT_PRODUTO),
            CONSTRAINT PROD_FK01 FOREIGN KEY (IDT_CATEGORIA_PRODUTO) REFERENCES TAB_CATEGORIA_PRODUTO (IDT_CATEGORIA_PRODUTO),
			CONSTRAINT PROD_UK01 UNIQUE (DES_PRODUTO),
			CONSTRAINT PROD_CK01 CHECK (FLG_ATIVO IN (0,1))
        ) COMMENT = ''[NOT_SECURITY_APPLY] - Tabela responsável por armazenar os Produtos.'''
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
               AND table_name = 'TAB_PRODUTO'
			   AND index_name = 'PROD_IDX01'
        ),
        'SELECT ''Índice PROD_IDX01 já existe''',
        'CREATE INDEX PROD_IDX01 ON TAB_PRODUTO(FLG_ATIVO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_PRODUTO (IDT_CATEGORIA_PRODUTO,DES_PRODUTO,DES_IMAGEM_PROD,VAL_PRODUTO_UNIT,FLG_ATIVO,DAT_CRIACAO,DAT_ATUALIZACAO,USR_CRIACAO,USR_ALTERACAO) VALUES
	 (1,'Nintendo Switch 2','asdasdasd',4200.99,1,'2026-06-17 01:52:40','2026-06-17 01:52:40',1,NULL);
