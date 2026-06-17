/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade CIDADE
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
               AND table_name = 'TAB_ENDERECO_CLIENTE'
        ),
        'SELECT ''Tabela TAB_ENDERECO_CLIENTE já existe''',
        'CREATE TABLE TAB_ENDERECO_CLIENTE (
            IDT_ENDERECO_CLIENTE BIGINT NOT NULL AUTO_INCREMENT 					 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela CLIENTE.'',
			IDT_CLIENTE BIGINT NOT NULL								 				 COMMENT ''[NOT_SECURITY_APPLY] - FK para a tabela CLIENTE.'',
			IDT_CIDADE BIGINT NOT NULL												 COMMENT ''[NOT_SECURITY_APPLY] - FK para a tabela Cidade.'',
			DES_LOGRADOURO VARCHAR(150) NOT NULL 							 		 COMMENT ''[PII] - Logradouro do Cliente.'',
			DES_COMPLEMENTO VARCHAR(100) NOT NULL									 COMMENT ''[PII] - Complemento do endereço do cliente.'',
			DES_BAIRRO VARCHAR(100) NOT NULL										 COMMENT ''[PII] - Bairro do cliente.'',
			DES_NUMERO VARCHAR(10) NOT NULL											 COMMENT ''[PII] - Número do endereço do cliente.'',
			NUM_CEP VARCHAR(8)	NOT NULL											 COMMENT ''[PII] - CEP do cliente.'',
            FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1					 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se o cliente está ativo ou não. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            USR_CRIACAO BIGINT NOT NULL 								 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            USR_ALTERACAO BIGINT 										 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT ENDCLI_PK PRIMARY KEY (IDT_ENDERECO_CLIENTE),
            CONSTRAINT ENDCLI_FK01 FOREIGN KEY (IDT_CLIENTE) REFERENCES TAB_CLIENTE (IDT_CLIENTE),
			CONSTRAINT ENDCLI_FK02 FOREIGN KEY (IDT_CIDADE) REFERENCES TAB_CIDADE (IDT_CIDADE)
        ) COMMENT = ''[PII] - Tabela responsável por armazenar o endereço dos clientes.'''
    )
);


PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- #INDICES# --

SET @sql2 := (
    SELECT IF(
        EXISTS (
            SELECT 1
              FROM information_schema.statistics
             WHERE table_schema = DATABASE()
               AND table_name = 'TAB_ENDERECO_CLIENTE'
			   AND index_name = 'ENDCLI_IDX01'
        ),
        'SELECT ''Índice ENDCLI_IDX01 já existe''',
        'CREATE INDEX ENDCLI_IDX01 ON TAB_ENDERECO_CLIENTE(FLG_ATIVO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO pje_adm.TAB_ENDERECO_CLIENTE (IDT_CLIENTE,IDT_CIDADE,DES_LOGRADOURO,DES_COMPLEMENTO,DES_BAIRRO,DES_NUMERO,NUM_CEP,FLG_ATIVO,DAT_CRIACAO,DAT_ATUALIZACAO,USR_CRIACAO,USR_ALTERACAO) VALUES (1,12,'teste','teste','teste','teste','123123',1,'2026-06-17 01:51:05','2026-06-17 01:51:05',1,NULL);
