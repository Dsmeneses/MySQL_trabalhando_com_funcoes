/*Funções de agregação*/

SELECT * FROM alugueis;
-- AVG - Média(Average)
SELECT AVG(nota) AS Media_Total FROM avaliacoes;

-- Categorizando as médias por tipo de hospedagem
SELECT * FROM hospedagens;

SELECT AVG(a.nota) AS Media_Total, h.tipo AS Tipo_hospedagem FROM avaliacoes AS a
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
GROUP BY h.tipo;

-- Maior Valor pago, Menor valor pago, Total pago
SELECT SUM(preco_total) AS Total_soma, MAX(preco_total) AS Maior_valor, MIN(preco_total) AS Menor_valor 
FROM alugueis;

-- Maior Valor pago, Menor valor pago, Total pago, por tipo de hospedagem
SELECT h.tipo, SUM(a.preco_total) AS Total_soma, MAX(a.preco_total) AS Maior_valor, 
MIN(a.preco_total) AS Menor_valor FROM alugueis AS a
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
GROUP BY h.tipo;

/************************************************************************************/


/*Funções para trabalhar com String*/
SELECT * FROM clientes;

-- Retornar o nome e o contato do cliente
SELECT nome, contato FROM clientes;
-- Retornar o nome e o contato do cliente usando concatenação
SELECT CONCAT(nome,'. O email é: ' ,contato) AS Nome_Contato FROM clientes;

-- Remover espaços do início e no fim da String- TRIM
SELECT CONCAT(TRIM(nome),'. O email é: ' ,contato) AS Nome_Contato FROM clientes;

-- Padronizar o CPF
SELECT TRIM(nome) AS Nome, CONCAT(SUBSTRING(cpf, 1,3),'.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3),  '-', SUBSTRING(cpf, 10, 2)) AS CPF_padronizado FROM clientes;

/************************************************************************************/


/*Funções para manipular datas*/

SELECT * FROM alugueis;

SELECT NOW() AS Hoje;

-- Diferença de dias, Data Inicio e Data Fim (DATEDIFF)

SELECT DATEDIFF(data_fim, data_inicio) AS Dias FROM alugueis;

-- Diferença de dias, Data Inicio e Data Fim (DATEDIFF), mais o nome dos clientes

SELECT TRIM(c.nome) AS Nome, DATEDIFF(a.data_fim, a.data_inicio) AS Dias FROM alugueis a
JOIN clientes c ON c.cliente_id = a.cliente_id;

-- Diferença de dias, Data Inicio e Data Fim (DATEDIFF), mais o tipo de hospedagens

SELECT h.tipo AS Tipo_hospedagem, SUM(DATEDIFF(a.data_fim, a.data_inicio)) AS Dias FROM alugueis a
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
GROUP BY h.tipo;

/************************************************************************************/

/*Funções numéricas e condicionais*/

/* Definindo quantas casas decimais ficarão após a vírgula ou ponto.*/

-- Arredondar o valor (ROUND)
SELECT ROUND(AVG(a.nota),2) AS Media_Total, h.tipo AS Tipo_hospedagem FROM avaliacoes AS a
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
GROUP BY h.tipo;

-- Cortar  casas decimais (TRUNCATE)
SELECT TRUNCATE(AVG(a.nota), 2) AS Media_Total, h.tipo AS Tipo_hospedagem FROM avaliacoes AS a
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
GROUP BY h.tipo;

/*Funções Condicionais*/

SELECT hospedagem_id, nota, 
CASE nota
	WHEN 5 THEN 'Excelente'
	WHEN 4 THEN 'Ótima'    
    WHEN 3 THEN 'Muito Boa'    
    WHEN 2 THEN 'Boa'
    ELSE 'Ruim'
END AS StatusNota
FROM avaliacoes;


