/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade STATUS_PEDIDO
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
               AND table_name = 'TAB_STATUS_PEDIDO'
        ),
        'SELECT ''Tabela TAB_STATUS_PEDIDO já existe''',
        'CREATE TABLE TAB_STATUS_PEDIDO (
            IDT_STATUS_PEDIDO BIGINT NOT NULL AUTO_INCREMENT 					 	 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela STATUS_PEDIDO.'',
			DES_STATUS_PEDIDO VARCHAR(50) NOT NULL 									 COMMENT ''[NOT_SECURITY_APPLY] - Descrição do status do pedido.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 			 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT STATPED_PK PRIMARY KEY (IDT_STATUS_PEDIDO),
			CONSTRAINT STATPED_UK01 UNIQUE (DES_STATUS_PEDIDO)
        ) COMMENT = ''[NOT_SECURITY_APPLY] - Tabela responsável por armazenar os Status dos Pedidos.'''
    )
);


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_STATUS_PEDIDO (DES_STATUS_PEDIDO,DAT_CRIACAO,DAT_ATUALIZACAO,IDT_USR_CRIACAO,IDT_USR_ALTERACAO) VALUES
	 ('Pendente','2026-06-17 01:53:44','2026-06-17 01:53:44',1,NULL),
	 ('Enviado','2026-06-17 01:53:44','2026-06-17 01:53:44',1,NULL),
	 ('Concluído','2026-06-17 01:53:44','2026-06-17 01:53:44',1,NULL) ON DUPLICATE KEY UPDATE IDT_USR_ALTERACAO = VALUES( IDT_USR_ALTERACAO), DAT_ATUALIZACAO = CURRENT_TIMESTAMP;
	 COMMIT;
