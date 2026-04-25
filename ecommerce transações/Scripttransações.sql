-- Desabilitando o autocommit para controle total
SET autocommit = 0;

-- Iniciando a transação
START TRANSACTION;

-- Cenário: Reajuste de 10% nos preços da categoria 'Smartphones' (idCategoria = 2)
UPDATE Produto 
SET preco = preco * 1.10 
WHERE idCategoria = 2;

-- Verificação: Consultar para ver se o reajuste está correto
SELECT idProduto, nome, preco FROM Produto WHERE idCategoria = 2;

-- Se tudo estiver ok, confirmamos
COMMIT;

-- Se algo deu errado durante o SELECT, usaríamos:
-- ROLLBACK;

DELIMITER $$

CREATE PROCEDURE sp_inserir_pedido_seguro(
    IN p_idConta INT,
    IN p_idEndereco INT,
    IN p_idProduto INT,
    IN p_quantidade INT,
    IN p_valorUnitario DECIMAL(10,2)
)
BEGIN
    -- Declaração de variável para controle de erro
    DECLARE erro_sql TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

    -- 1. Insere o cabeçalho do pedido
    INSERT INTO Pedido (idConta, idEnderecoEntrega, status, valorTotal) 
    VALUES (p_idConta, p_idEndereco, 'Aguardando Pagamento', (p_quantidade * p_valorUnitario));

    -- 2. Recupera o ID do pedido inserido
    SET @novo_pedido_id = LAST_INSERT_ID();

    -- 3. Insere o item do pedido
    INSERT INTO Item_Pedido (idPedido, idProduto, quantidade, valorUnitario)
    VALUES (@novo_pedido_id, p_idProduto, p_quantidade, p_valorUnitario);

    -- Verificação de erro
    IF erro_sql THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na transação: Pedido cancelado e dados revertidos.';
    ELSE
        COMMIT;
    END IF;
END $$

DELIMITER ;