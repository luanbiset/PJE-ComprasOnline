/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE011 >> Relatório de vendas por valor minimo
-- DATA :        16/06/2026
-- AUTOR:        Luan Biset
-- SISTEMA:      PJE - Compras On-line
---------------------------------------------------------------------------------------------------
*/

USE pje_adm;

-- +---------------------------------------------------------+--
-- 1. Exclusao da procedure de migration
-- +---------------------------------------------------------+--
DROP PROCEDURE IF EXISTS pje_adm.sp_listar_pedido_valor_min;

-- +---------------------------------------------------------+--
-- 2. Criacao da procedure de migration
-- +---------------------------------------------------------+--
DELIMITER ||

CREATE PROCEDURE pje_adm.sp_listar_pedido_valor_min(
    IN vInicioPeriodo DATE,
    IN vFimPeriodo DATE,
    IN vCategoria VARCHAR(100),
    IN vStatus VARCHAR(100),
    IN vValorMin DECIMAL(12,2),
    IN vNumPag INT,
    IN vNumRegPag INT
)
BEGIN
	DECLARE vOffSet INT;

    SET vInicioPeriodo = TIMESTAMP(DATE(vInicioPeriodo), '00:00:00');
    SET vFimPeriodo    = TIMESTAMP(DATE(vFimPeriodo), '23:59:59');
    SET vValorMin = IFNULL(vValorMin,1000);
    SET vStatus = IFNULL(vStatus,'Concluído');
    SET vNumRegPag = IFNULL(vNumRegPag,50);
    
    SET vOffSet = (vNumPag - 1) * vNumRegPag;

    IF DATEDIFF(vFimPeriodo, vInicioPeriodo) > 90 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O período de dias informado não pode exceder 90 dias';
    END IF;

  
         SELECT
            CLI.NAM_CLIENTE,
            PED.IDT_PEDIDO,
            PED.VAL_TOTAL_PEDIDO,
            PROD.DES_PRODUTO AS PRODUTO
			
        FROM pje_adm.TAB_CLIENTE CLI
        INNER JOIN pje_adm.TAB_PEDIDO PED
            ON CLI.IDT_CLIENTE = PED.IDT_CLIENTE
        INNER JOIN pje_adm.TAB_STATUS_PEDIDO STATPED
            ON STATPED.IDT_STATUS_PEDIDO = PED.IDT_STATUS_PEDIDO
        INNER JOIN pje_adm.TAB_ITEM_PEDIDO  ITEPED
			ON ITEPED.IDT_PEDIDO  = PED.IDT_PEDIDO
		inner join pje_adm.TAB_PRODUTO PROD
			ON PROD.IDT_PRODUTO = ITEPED.IDT_PRODUTO
        WHERE PED.DAT_PEDIDO BETWEEN vInicioPeriodo AND vFimPeriodo
          AND PED.VAL_TOTAL_PEDIDO > vValorMin
          AND (vStatus IS NULL OR STATPED.DES_STATUS_PEDIDO = vStatus)
        ORDER BY PED.DAT_PEDIDO DESC
        LIMIT vNumRegPag OFFSET vOffSet;

END ||

DELIMITER ;

/*
USE pje_adm;
CALL pje_adm.sp_listar_pedido_valor_min(
    '2026-06-01',
    '2026-06-30',
    'Games',
    'Pendente',
    NULL,
    NULL,
   	NULL
);
*/

