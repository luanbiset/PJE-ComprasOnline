/*
---------------------------------------------------------------------------------------------------
-- MOTIVO:       PJE014 >> Trigger para atualização do valor total do pedido após alteração nos itens do pedido.
-- DATA :        17/06/2026
-- AUTOR:        Luan Biset
-- SISTEMA:      PJE - Compras On-line
---------------------------------------------------------------------------------------------------
*/

USE pje_adm;

-- +---------------------------------------------------------+--
-- 1. Exclusao da procedure de migration
-- +---------------------------------------------------------+--
DROP TRIGGER IF EXISTS TRU_PEDIDO;

-- +---------------------------------------------------------+--
-- 2. Criacao da procedure de migration
-- +---------------------------------------------------------+--
DELIMITER $$
CREATE TRIGGER TRU_PEDIDO
AFTER UPDATE ON TAB_ITEM_PEDIDO
FOR EACH ROW
BEGIN
    UPDATE TAB_PEDIDO p
    SET p.VAL_TOTAL_PEDIDO = (
        SELECT COALESCE(SUM(i.VAL_FINAL_ITEM * i.QTD_ITEM), 0)
        FROM TAB_ITEM_PEDIDO i
        WHERE i.IDT_PEDIDO = NEW.IDT_PEDIDO
    )
    WHERE p.IDT_PEDIDO = NEW.IDT_PEDIDO;
END$$

DELIMITER ;
