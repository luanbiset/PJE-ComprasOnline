/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE-001 >> Criação da entidade UF
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
               AND table_name = 'TAB_UF'
        ),
        'SELECT ''Tabela TAB_UF já existe''',
        'CREATE TABLE TAB_UF (
            IDT_UF TINYINT NOT NULL AUTO_INCREMENT 					 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela UF.'',
            COD_UF TINYINT NOT NULL 								 COMMENT ''[NOT_SECURITY_APPLY] - Código único da UF.'',
            NAM_UF VARCHAR(100) NOT NULL 							 COMMENT ''[NOT_SECURITY_APPLY] - Nome da UF.'',
            SG_UF CHAR(2) NOT NULL 									 COMMENT ''[NOT_SECURITY_APPLY] - Sigla da UF.'',
            FLG_ATIVO TINYINT(1) NOT NULL DEFAULT 1					 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se a UF está ativa ou não. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de criação da UF.'',
            DAT_ATUALIZACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização da UF.'',
            IDT_USR_CRIACAO BIGINT NOT NULL COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT UF_PK PRIMARY KEY (IDT_UF),
            CONSTRAINT UF_UK01 UNIQUE (COD_UF),
            CONSTRAINT UF_UK02 UNIQUE (NAM_UF),
            CONSTRAINT UF_UK03 UNIQUE (SG_UF)
        ) COMMENT = ''[NOT_SECURITY_APPLY] - Tabela responsável por armazenar as UF do Brasil.'''
    )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

insert into TAB_UF (COD_UF,NAM_UF,SG_UF,DAT_CRIACAO,DAT_ATUALIZACAO,IDT_USR_CRIACAO) values (5,'BAHIA','BA',current_timestamp,current_timestamp,1) ON DUPLICATE KEY UPDATE COD_UF = values (COD_UF), NAM_UF = Values(NAM_UF), SG_UF = VALUES (SG_UF);