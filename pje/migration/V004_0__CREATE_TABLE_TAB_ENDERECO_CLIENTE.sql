/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade ENDERECO_CLIENTE
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
			IDT_CIDADE INT NOT NULL													 COMMENT ''[NOT_SECURITY_APPLY] - FK para a tabela Cidade.'',
			DES_LOGRADOURO VARCHAR(150) NOT NULL 							 		 COMMENT ''[PII] - Logradouro do Cliente.'',
			DES_COMPLEMENTO VARCHAR(100) 											 COMMENT ''[PII] - Complemento do endereço do cliente.'',
			DES_BAIRRO VARCHAR(100) NOT NULL										 COMMENT ''[PII] - Bairro do cliente.'',
			DES_NUMERO VARCHAR(10) NOT NULL											 COMMENT ''[PII] - Número do endereço do cliente.'',
			NUM_CEP VARCHAR(10)	NOT NULL											 COMMENT ''[PII] - CEP do cliente.'',
            FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1					 	 			 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se o cliente está ativo ou não. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 	 COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL 								 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT 										 COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT ENDCLI_PK PRIMARY KEY (IDT_ENDERECO_CLIENTE),
            CONSTRAINT ENDCLI_FK01 FOREIGN KEY (IDT_CLIENTE) REFERENCES TAB_CLIENTE (IDT_CLIENTE),
			CONSTRAINT ENDCLI_FK02 FOREIGN KEY (IDT_CIDADE) REFERENCES TAB_CIDADE (IDT_CIDADE),
			CONSTRAINT ENDCLI_UK01 UNIQUE (IDT_CLIENTE,DES_LOGRADOURO,DES_NUMERO,NUM_CEP),
			CONSTRAINT ENDCLI_CK01 CHECK (FLG_ATIVO IN (0,1))
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
        'CREATE INDEX ENDCLI_IDX01 ON TAB_ENDERECO_CLIENTE(IDT_CLIENTE,FLG_ATIVO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @IDT_CLIENTE = (SELECT IDT_CLIENTE FROM TAB_CLIENTE WHERE NUM_CPF = '01212332122');

SET @IDT_CIDADE = (SELECT IDT_CIDADE FROM TAB_CIDADE WHERE COD_CIDADE = 2927408);

INSERT INTO pje_adm.TAB_ENDERECO_CLIENTE (IDT_CLIENTE,IDT_CIDADE,DES_LOGRADOURO,DES_COMPLEMENTO,DES_BAIRRO,DES_NUMERO,NUM_CEP,FLG_ATIVO,DAT_CRIACAO,DAT_ATUALIZACAO,IDT_USR_CRIACAO,IDT_USR_ALTERACAO) 
VALUES (@IDT_CLIENTE,@IDT_CIDADE,'teste','teste','teste','teste','123123',1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,NULL) 
ON DUPLICATE KEY UPDATE DES_LOGRADOURO = VALUES(DES_LOGRADOURO), DES_COMPLEMENTO = VALUES(DES_COMPLEMENTO), DES_BAIRRO = VALUES(DES_BAIRRO), DES_NUMERO = VALUES(DES_NUMERO), NUM_CEP = VALUES(NUM_CEP);
COMMIT;
