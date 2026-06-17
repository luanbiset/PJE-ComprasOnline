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
               AND table_name = 'TAB_CIDADE'
        ),
        'SELECT ''Tabela TAB_CIDADE já existe''',
        'CREATE TABLE TAB_CIDADE (
            IDT_CIDADE BIGINT NOT NULL AUTO_INCREMENT 					 COMMENT ''[NOT_SECURITY_APPLY] - Chave primária da tabela Cidade.'',
			IDT_UF TINYINT NOT NULL								 	 COMMENT ''[NOT_SECURITY_APPLY] - Chave estrangeira para a tabela TAB_UF.'',
			COD_CIDADE INT NOT NULL 							 COMMENT ''[NOT_SECURITY_APPLY] - Código único da cidade no IBGE.'',
            NAM_CIDADE VARCHAR(100) NOT NULL 						 COMMENT ''[NOT_SECURITY_APPLY] - Nome da Cidade.'',
            FLG_ATIVO TINYINT(1) NOT NULL 							 COMMENT ''[NOT_SECURITY_APPLY] - Flag que indica se o registro está ativo ou não. Aceita os valores (1) Ativo e (0) Inativo.'',
            DAT_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de criação do registro.'',
            DAT_ATUALIZACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''[NOT_SECURITY_APPLY] - Data de atualização do registro.'',
            IDT_USR_CRIACAO BIGINT NOT NULL COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela criação do registro.'',
            IDT_USR_ALTERACAO BIGINT COMMENT ''[NOT_SECURITY_APPLY] - Usuário responsável pela alteração do registro.'',
            CONSTRAINT CID_PK PRIMARY KEY (IDT_CIDADE),
            CONSTRAINT CID_UK01 UNIQUE (COD_CIDADE),
            CONSTRAINT CID_UK02 UNIQUE (IDT_UF,NAM_CIDADE),
			CONSTRAINT CID_FK01 FOREIGN KEY (IDT_UF) REFERENCES TAB_UF(IDT_UF)
        ) COMMENT = ''[NOT_SECURITY_APPLY] - Tabela responsável por armazenar as Cidades do Brasil.'''
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
               AND table_name = 'TAB_CIDADE'
			   AND index_name = 'CID_IDX01'
        ),
        'SELECT ''Índice CID_IDX01 já existe''',
        'CREATE INDEX CID_IDX01 ON TAB_CIDADE(FLG_ATIVO)'
    )
);

PREPARE stmt FROM @sql2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO TAB_CIDADE
(
    IDT_UF,
    COD_CIDADE,
    NAM_CIDADE,
    FLG_ATIVO,
    IDT_USR_CRIACAO
)
VALUES
(1, 2900108, 'Abaíra', 1, 1),
(1, 2900207, 'Abaré', 1, 1),
(1, 2900306, 'Acajutiba', 1, 1),
(1, 2900405, 'Água Fria', 1, 1),
(1, 2900702, 'Alagoinhas', 1, 1),
(1, 2901007, 'Amargosa', 1, 1),
(1, 2903201, 'Barreiras', 1, 1),
(1, 2905701, 'Camaçari', 1, 1),
(1, 2910800, 'Feira de Santana', 1, 1),
(1, 2913606, 'Ilhéus', 1, 1),
(1, 2914802, 'Itabuna', 1, 1),
(1, 2927408, 'Salvador', 1, 1),
(1, 2933307, 'Vitória da Conquista', 1, 1) ON DUPLICATE KEY UPDATE COD_CIDADE = VALUES(COD_CIDADE), NAM_CIDADE = VALUES(NAM_CIDADE);
commit;