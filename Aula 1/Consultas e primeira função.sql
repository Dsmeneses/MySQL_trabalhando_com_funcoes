/*Aula 1*/
/*Consultas e primeira função*/

SELECT * FROM alugueis;

SELECT
	(SELECT COUNT(*) FROM alugueis) AS Total_Aluguel,
	(SELECT COUNT(*) FROM avaliacoes) AS Total_Avaliacoes,
	(SELECT COUNT(*) FROM clientes) AS Total_Clientes,
	(SELECT COUNT(*) FROM enderecos) AS Total_Enderecos,
	(SELECT COUNT(*) FROM hospedagens) AS Total_Hospedagens,
	(SELECT COUNT(*) FROM proprietarios) AS Total_Proprietarios;

