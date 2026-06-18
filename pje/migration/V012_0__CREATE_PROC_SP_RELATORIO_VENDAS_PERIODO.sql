/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE012 -- Relatório de vendas por período e categoria
-- DATA :        16/06/2026
-- AUTOR:        Luan Biset
-- SISTEMA:      PJE - Compras On-line
---------------------------------------------------------------------------------------------------
*/

USE pje_adm;

-- +---------------------------------------------------------+--
-- 1. Exclusao da procedure de migration
-- +---------------------------------------------------------+--
drop procedure if exists pje_adm.sp_relatorio_vendas_periodo;

-- +---------------------------------------------------------+--
-- 2. Criacao da procedure de migration
-- +---------------------------------------------------------+--
DELIMITER ||

CREATE PROCEDURE pje_adm.sp_relatorio_vendas_periodo(
    IN vInicioPeriodo DATE,
    IN vFimPeriodo DATE,
    IN vCategoria VARCHAR(100),
    OUT vResult JSON
)
BEGIN
    DECLARE vQtd BIGINT DEFAULT 0;
    DECLARE vValorTotal DECIMAL(12,2) DEFAULT 0.00;
    DECLARE vValorMedio DECIMAL(12,2) DEFAULT 0.00;
    DECLARE vProdutoVendido JSON DEFAULT JSON_ARRAY();

    SET vInicioPeriodo = TIMESTAMP(DATE(vInicioPeriodo), '00:00:00');
    SET vFimPeriodo    = TIMESTAMP(DATE(vFimPeriodo), '23:59:59');

    SELECT
        COUNT(1),
        ROUND(IFNULL(SUM(PED.VAL_TOTAL_PEDIDO), 0), 2),
        ROUND(IFNULL(AVG(PED.VAL_TOTAL_PEDIDO), 0), 2)
    INTO vQtd, vValorTotal, vValorMedio
    FROM pje_adm.TAB_PEDIDO PED
    WHERE PED.DAT_PEDIDO BETWEEN vInicioPeriodo AND vFimPeriodo;

    SELECT IFNULL(JSON_ARRAYAGG(
                  	 JSON_OBJECT('DES_PRODUTO', DES_PRODUTO, 'QTD_ITEM', QTD_TOTAL_VENDIDO) ), JSON_ARRAY() )
    INTO vProdutoVendido
    FROM (
        SELECT
            PROD.DES_PRODUTO,
            SUM(ITEMPED.QTD_ITEM) AS QTD_TOTAL_VENDIDO
        FROM pje_adm.TAB_ITEM_PEDIDO ITEMPED
        INNER JOIN pje_adm.TAB_PEDIDO PED ON ITEMPED.IDT_PEDIDO = PED.IDT_PEDIDO
        INNER JOIN pje_adm.TAB_PRODUTO PROD ON ITEMPED.IDT_PRODUTO = PROD.IDT_PRODUTO
        INNER JOIN pje_adm.TAB_CATEGORIA_PRODUTO CATPROD ON PROD.IDT_CATEGORIA_PRODUTO = CATPROD.IDT_CATEGORIA_PRODUTO
        WHERE PED.DAT_PEDIDO BETWEEN vInicioPeriodo AND vFimPeriodo
        AND (vCategoria IS NULL OR CATPROD.DES_CATEGORIA = vCategoria)
        GROUP BY PROD.DES_PRODUTO
    ) TB;

    SET vResult = JSON_OBJECT(
        'QtdTotal', vQtd,
        'ValorTotal', vValorTotal,
        'ValorMedio', vValorMedio,
        'ProdutosVendidos', vProdutoVendido
    );

END ||

DELIMITER ;

/*
 USE pje_adm;
 call pje_adm.sp_relatorio_vendas_periodo('2026-01-01',
     '2026-06-30',
    'Games',
    @report
);
SELECT @report AS report_venda_periodo;
*/