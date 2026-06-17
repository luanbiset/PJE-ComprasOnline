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
            IDT_ITEM_PEDIDO BIGINT NOT NULL AUTO_INCREMENT 					 		 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela PRODUTO.'',
			IDT_PEDIDO BIGINT NOT NULL									 			 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela CLIENTE.'',
			IDT_PRODUTO BIGINT NOT NULL												 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela PRODUTO.'',
			QTD_ITEM INT NOT NULL										 			 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela STATUS_PEDIDO.'',
			DES_UNI_MEDIDA VARCHAR(20)												 COMMENT ''[NOT_SECURITY_APPLY] - Indica a unidade de medida do pedido. Kilos, pacotes, litros, etc.'',
			VAL_TOTAL_ITEM DECIMAL(12,2) NOT NULL									 COMMENT ''[STRATEGIC_FIN] - Valor total do item no pedido.'',
			VAL_DESCONTO DECIMAL(12,2) NOT NULL									 	 COMMENT ''[STRATEGIC_FIN] - Valor de desconto por item.'',
			VAL_FINAL_ITEM DECIMAL(12,2) NOT NULL									 COMMENT ''[STRATEGIC_FIN] - Valor final do item após aplicado o desconto.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT ITEMPED_PK PRIMARY KEY (IDT_ITEM_PEDIDO),
            CONSTRAINT ITEMPED_FK01 FOREIGN KEY (IDT_PEDIDO) REFERENCES TAB_PEDIDO (IDT_PEDIDO),
			CONSTRAINT ITEMPED_FK02 FOREIGN KEY (IDT_PRODUTO) REFERENCES TAB_PRODUTO (IDT_PRODUTO),
			CONSTRAINT ITEMPED_UK01 UNIQUE (IDT_PEDIDO,IDT_PRODUTO)
        ) COMMENT = ''[NOT_SECURITY_APPLY] - Tabela responsável por armazenar os items dos pedidos.'''
    )
);


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_ITEM_PEDIDO (IDT_PEDIDO,IDT_PRODUTO,QTD_ITEM,DES_UNI_MEDIDA,VAL_TOTAL_ITEM,VAL_DESCONTO,VAL_FINAL_ITEM,DAT_CRIACAO,DAT_ATUALIZACAO,USR_CRIACAO,USR_ALTERACAO) VALUES
	 (1,1,1,'Unidade',4200.99,0.00,4200.99,'2026-06-17 01:55:16','2026-06-17 01:55:16',1,NULL)
	 ON DUPLICATE KEY UPDATE QTD_ITEM = VALUES (QTD_ITEM), DES_UNI_MEDIDA = VALUES (DES_UNI_MEDIDA), VAL_TOTAL_ITEM = VALUES(VAL_TOTAL_ITEM), VAL_DESCONTO = VALUES (VAL_DESCONTO), VAL_FINAL_ITEM = VALUES(VAL_FINAL_ITEM), DAT_ATUALIZACAO = CURRENT_TIMESTAMP, USR_ALTERACAO = 1;
	 COMMIT;