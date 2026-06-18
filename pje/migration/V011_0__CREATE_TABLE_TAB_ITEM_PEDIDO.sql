/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade ITEM_PEDIDO
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
               AND table_name = 'TAB_ITEM_PEDIDO'
        ),
        'SELECT ''Tabela TAB_ITEM_PEDIDO já existe''',
        'CREATE TABLE TAB_ITEM_PEDIDO (
            IDT_ITEM_PEDIDO BIGINT NOT NULL AUTO_INCREMENT 					 		 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela ITEM_PEDIDO.'',
			IDT_PEDIDO BIGINT NOT NULL									 			 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela PEDIDO.'',
			IDT_PRODUTO BIGINT NOT NULL												 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela PRODUTO.'',
			QTD_ITEM INT NOT NULL										 			 COMMENT ''[NOT_SECURITY_APPLY] - Quantidade de itens do pedido.'',
			DES_UNI_MEDIDA VARCHAR(20) NOT NULL										 COMMENT ''[NOT_SECURITY_APPLY] - Indica a unidade de medida do pedido. Kilos, pacotes, litros, etc.'',
			VAL_TOTAL_ITEM DECIMAL(12,2) NOT NULL									 COMMENT ''[STRATEGIC_FIN] - Valor total do item no pedido.'',
			VAL_DESCONTO DECIMAL(12,2) NOT NULL	DEFAULT 0						 	 COMMENT ''[STRATEGIC_FIN] - Valor de desconto por item.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT ITEPED_PK PRIMARY KEY (IDT_ITEM_PEDIDO),
            CONSTRAINT ITEPED_FK01 FOREIGN KEY (IDT_PEDIDO) REFERENCES TAB_PEDIDO (IDT_PEDIDO),
			CONSTRAINT ITEPED_FK02 FOREIGN KEY (IDT_PRODUTO) REFERENCES TAB_PRODUTO (IDT_PRODUTO),
			CONSTRAINT ITEPED_UK01 UNIQUE (IDT_PEDIDO,IDT_PRODUTO),
			CONSTRAINT ITEPED_CK01 CHECK (QTD_ITEM > 0)
        ) COMMENT = ''[STRATEGIC_FIN] - Tabela responsável por armazenar os itens dos pedidos.'''
    )
);


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
