
USE pje_adm;
DROP PROCEDURE IF EXISTS SP_CARGA_PJE;
DELIMITER $$

CREATE PROCEDURE SP_CARGA_PJE()
BEGIN
    DECLARE v_cliente INT DEFAULT 0;
    DECLARE v_pedido INT DEFAULT 0;

    DECLARE v_id_cliente BIGINT;
    DECLARE v_id_pedido BIGINT;
    DECLARE v_id_produto BIGINT;
    DECLARE v_id_status BIGINT;

    
    SELECT IDT_STATUS_PEDIDO INTO v_id_status
    FROM TAB_STATUS_PEDIDO
    LIMIT 1;

    
    SELECT IDT_PRODUTO INTO v_id_produto
    FROM TAB_PRODUTO
    LIMIT 1;


    WHILE v_cliente < 1000 DO

        INSERT INTO TAB_CLIENTE (
            NAM_CLIENTE,
            NUM_CPF,
            DAT_NASCIMENTO,
            DAT_CRIACAO,
            DAT_ATUALIZACAO,
            IDT_USR_CRIACAO
        )
        VALUES (
            CONCAT('Cliente ', v_cliente),
            LPAD(FLOOR(RAND() * 100000000000), 11, '0'),
            DATE_SUB(CURDATE(), INTERVAL (18 + FLOOR(RAND() * 47)) YEAR),
            NOW(),
            NOW(),
            1
        );

        SET v_id_cliente = LAST_INSERT_ID();

        
        INSERT INTO TAB_ENDERECO_CLIENTE (
            IDT_CLIENTE, IDT_CIDADE, DES_LOGRADOURO, DES_COMPLEMENTO,
            DES_BAIRRO, DES_NUMERO, NUM_CEP, FLG_ATIVO,
            DAT_CRIACAO, DAT_ATUALIZACAO, IDT_USR_CRIACAO
        )
        VALUES (
            v_id_cliente,
            1,
            CONCAT('Rua Teste ', v_cliente),
            'Casa',
            'Centro',
            '100',
            '40000000',
            1,
            NOW(),
            NOW(),
            1
        );

        
        INSERT INTO TAB_EMAIL_CLIENTE (
            IDT_CLIENTE, DES_EMAIL, FLG_ATIVO,
            DAT_CRIACAO, DAT_ATUALIZACAO, IDT_USR_CRIACAO
        )
        VALUES (
            v_id_cliente,
            CONCAT('cliente', v_cliente, '@mail.com'),
            1,
            NOW(),
            NOW(),
            1
        );

        
        INSERT INTO TAB_TELEFONE_CLIENTE (
            IDT_CLIENTE, COD_DDD, NUM_TELEFONE, TP_TELEFONE, FLG_PRINCIPAL,
            DAT_CRIACAO, DAT_ATUALIZACAO, IDT_USR_CRIACAO
        )
        VALUES (
            v_id_cliente,
            '71',
            CONCAT('999000', LPAD(v_cliente, 3, '0')),
            1,
            1,
            NOW(),
            NOW(),
            1
        );

        
        -- 10 pedidos por cliente
        SET v_pedido = 0;

        WHILE v_pedido < 50 DO

            INSERT INTO TAB_PEDIDO (
                IDT_CLIENTE,
                IDT_STATUS_PEDIDO,
                NUM_PEDIDO,
                VAL_TOTAL_PEDIDO,
                DES_OBS,
                DAT_PEDIDO,
                DAT_ATUALIZACAO,
                IDT_USR_CRIACAO
            )
            VALUES (
                v_id_cliente,
                v_id_status,
				CONCAT(LPAD(FLOOR(RAND() * 10000), 4, '0'),DATE_FORMAT(NOW(6), '%d%m%Y%H%i%s%f')),
                0,
                'Pedido gerado via carga',
                NOW(),
                NOW(),
                1
            );

            SET v_id_pedido = LAST_INSERT_ID();

            -- 1 item por pedido
            INSERT INTO TAB_ITEM_PEDIDO (
                IDT_PEDIDO,
                IDT_PRODUTO,
                QTD_ITEM,
                DES_UNI_MEDIDA,
                VAL_TOTAL_ITEM,
                VAL_DESCONTO,
                DAT_CRIACAO,
                DAT_ATUALIZACAO,
                IDT_USR_CRIACAO
            )
            VALUES (
                v_id_pedido,
                v_id_produto,
                1,
                'UN',
                1200.00,
                0.00,
                NOW(),
                NOW(),
                1
            );

            SET v_pedido = v_pedido + 1;

        END WHILE;

        SET v_cliente = v_cliente + 1;

    END WHILE;

END$$

DELIMITER ;


call SP_CARGA_PJE();