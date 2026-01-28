/*Funções criadas pelo usuário*/


-- Criando uma função
DELIMITER $$

CREATE FUNCTION retorno_constante()
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
	RETURN 'Seja bem vindo(a)';
    
END$$

DELIMITER ;

SELECT retorno_constante();

/************************************************************************************/

/*Declarando variáveis*/

-- Montando uma função que armazena um Select dentro de uma variável, para reutilizar numa outra busca
-- EX: Media total de notas

SELECT ROUND(AVG(nota),2) AS Media_notas FROM avaliacoes;

DELIMITER $$

CREATE FUNCTION media_avaliacoes()
RETURNS FLOAT DETERMINISTIC
BEGIN

	DECLARE media FLOAT;
	SELECT ROUND(AVG(nota),2) AS Media_notas INTO media FROM avaliacoes;
	RETURN media;

END $$
DELIMITER ;

SELECT media_avaliacoes();

/************************************************************************************/

/*Utilizando parâmetros*/

-- Transformando a consulta/busca do CPF em uma Função

DROP FUNCTION IF EXISTS formatando_cpf;

DELIMITER $$

CREATE FUNCTION formatacao_cpf(Cliente_id INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN

	DECLARE novo_cpf VARCHAR(50);
    
    SET novo_cpf = (
    SELECT CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado FROM clientes
    WHERE cliente_id = Cliente_id);

	RETURN novo_cpf;
END$$

DELIMITER ;

SELECT formatacao_cpf(10);


/************************************************************************************/

/*Retornando mais de um valor*/

-- Construir uma função que retorna o nome e o valor de diária de cada hóspede

SELECT * FROM alugueis;

DELIMITER $$

CREATE FUNCTION info_aluguel(id_aluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	
    DECLARE nome_cliente VARCHAR(100);
    DECLARE preco_total DECIMAL(10,2);
    DECLARE dias INT;
	DECLARE valor_diaria DECIMAL(10,2);
    DECLARE resultado VARCHAR(100);

	SELECT c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio) INTO nome_cliente, preco_total, Dias
    FROM alugueis a
    JOIN clientes c ON c.cliente_id = a.cliente_id
    WHERE a.aluguel_id = id_aluguel;
    
	SET valor_diaria = preco_total / dias;
    SET resultado = CONCAT('Nome: ', nome_cliente, ', Valor Diário: R$', FORMAT(valor_diaria,2));
    
    RETURN resultado;
    
END$$

DELIMITER ;

SELECT info_aluguel(1);