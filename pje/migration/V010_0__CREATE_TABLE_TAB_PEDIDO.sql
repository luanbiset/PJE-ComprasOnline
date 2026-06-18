/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade PEDIDO
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
               AND table_name = 'TAB_PEDIDO'
        ),
        'SELECT ''Tabela TAB_PEDIDO já existe''',
        'CREATE TABLE TAB_PEDIDO (
            IDT_PEDIDO BIGINT NOT NULL AUTO_INCREMENT 					 			 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela PEDIDO.'',
			IDT_CLIENTE BIGINT NOT NULL									 			 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela CLIENTE.'',
			IDT_STATUS_PEDIDO BIGINT NOT NULL										 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela STATUS_PEDIDO.'',
			NUM_PEDIDO VARCHAR(30) NOT NULL										 			 COMMENT ''[STRATEGIC_FIN] - Número do pedido.'',
			VAL_TOTAL_PEDIDO DECIMAL(12,2) NOT NULL									 COMMENT ''[STRATEGIC_FIN] - Valor total do pedido.'',
			DES_OBS VARCHAR(300)												 	 COMMENT ''[NOT_SECURITY_APPLY] - Observações adicionadas ao pedido.'',
            DAT_PEDIDO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT PED_PK PRIMARY KEY (IDT_PEDIDO),
            CONSTRAINT PED_FK01 FOREIGN KEY (IDT_CLIENTE) REFERENCES TAB_CLIENTE (IDT_CLIENTE),
			CONSTRAINT PED_FK02 FOREIGN KEY (IDT_STATUS_PEDIDO) REFERENCES TAB_STATUS_PEDIDO (IDT_STATUS_PEDIDO),
			CONSTRAINT PED_UK01 UNIQUE (NUM_PEDIDO)
        ) COMMENT = ''[STRATEGIC_FIN] - Tabela responsável por armazenar os Pedidos.'''
    )
);


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql2 := 
(
    SELECT IF(
        EXISTS (
            SELECT 1
              FROM information_schema.statistics
             WHERE table_schema = DATABASE()
               AND index_name = 'PED_IDX01'
        ),
		'SELECT ''Índice PED_IDX01 já existe''',
		'CREATE INDEX PED_IDX01 ON TAB_PEDIDO(IDT_STATUS_PEDIDO,DAT_PEDIDO,VAL_TOTAL_PEDIDO)'
			 )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
