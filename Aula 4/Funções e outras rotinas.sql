/*Funções e outras rotinas*/

-- Criando um novo relatório

-- Desconto : cliente passar menos 4 dias, o cliente não tem direito a desconto
-- Desconto : cliente passar de 4 a 6 dias, o cliente tem direito a 5% de desconto
-- Desconto : cliente passar de 7 a 9 dias, o cliente tem direito a 10% de desconto
-- Desconto : cliente passar 10 ou mais dias, o cliente tem direito a 15% de desconto

SELECT * FROM alugueis;

-- Quais informções são necessárias?
-- cliente_id, data_fim, data_inicio
-- Diferença entre os dias

SELECT cliente_id, data_inicio, data_fim, DATEDIFF(data_fim, data_inicio) AS Dias,
CASE 
	WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
    
    WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10 
    
    WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
    
    ELSE 0
    
END AS Desconto_Percentual FROM alugueis;

-- Criação da Função

DELIMITER $$

CREATE FUNCTION desconto_por_dias(id_aluguel INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE desconto INT;
	SELECT 
		CASE 
			WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
			WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10 
			WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
			ELSE 0			
		END INTO desconto 
	FROM alugueis 
	WHERE aluguel_id = id_aluguel;
	RETURN desconto;
END$$

DELIMITER ;

SELECT desconto_por_dias(1);

/************************************************************************************/

/*Chamando função em uma função*/

-- Criando a função para calcular o desconto

DELIMITER $$

CREATE FUNCTION calcula_ValorFinal_com_desconto(id_aluguel INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	
	DECLARE valor_total DECIMAL(10,2);
    DECLARE valor_desconto INT;
    DECLARE valor_com_desconto DECIMAL(10,2);
    
	SELECT preco_total INTO valor_total FROM alugueis WHERE aluguel_id = id_aluguel;
    SET valor_desconto = desconto_por_dias(id_aluguel);
    SET valor_com_desconto = valor_total - (valor_total * valor_desconto /100);
    
	RETURN valor_com_desconto;
END$$

DELIMITER ;

SELECT calcula_ValorFInal_com_desconto(1);


/************************************************************************************/

/*Criando uma nova tabela*/

-- Criação de uma tabela com as seguintes informações:
-- % do desconto do cliente
-- valor sem o desconto
-- valor final

CREATE TABLE resumo_aluguel(
	aluguel_id VARCHAR(255),
    cliente_id VARCHAR(255),
    valor_total DECIMAL(10,2),
    desconto_aplicado DECIMAL(10,2),
    valor_final DECIMAL(10,2),
    PRIMARY KEY(aluguel_id, cliente_id),
    FOREIGN KEY(aluguel_id) REFERENCES alugueis(aluguel_id),
	FOREIGN KEY(cliente_id) REFERENCES clientes(cliente_id)
);

-- Como pegar os valores das funções para armazená-las nas tabelas??
-- R: Utilizando TRIGGERS

/************************************************************************************/

/*Trabalhando com Trigger*/

DELIMITER $$

CREATE TRIGGER insercao_na_tabela_resumo_aluguel
AFTER INSERT ON alugueis
FOR EACH ROW
BEGIN
	
    DECLARE valor_desconto INT;
    DECLARE valor_final DECIMAL(10,2);
    
	SET valor_desconto = desconto_por_dias(NEW.aluguel_id);
    SET valor_final = calcula_ValorFInal_com_desconto(NEW.aluguel_id);
	
    INSERT INTO resumo_aluguel(aluguel_id, cliente_id, valor_total, desconto_aplicado, valor_final)
	VALUES(NEW.aluguel_id, NEW.cliente_id, NEW.preco_total, valor_desconto, valor_final);
    
END$$

DELIMITER ;

-- Tabela vazia
SELECT * FROM resumo_aluguel;

-- Testando a TRIGGER inserindo dados
INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total)
VALUES (10001, 42, 15, '2024-01-01', '2024-01-08', 3000.00);

-- Tabela com os dados do registro acima
SELECT * FROM resumo_aluguel;