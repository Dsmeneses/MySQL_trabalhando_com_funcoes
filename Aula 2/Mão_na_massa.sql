/*Mão na massa 1*/

 /*Você é um analista de dados em uma plataforma de hospedagem que conecta proprietários de 
 imóveis com potenciais hóspedes. A plataforma coleta avaliações dos clientes após cada estadia, 
 e a equipe de gerenciamento quer entender melhor o desempenho das hospedagens em diferentes 
 cidades, além de identificar áreas de melhoria.

Desafio: Sua tarefa é criar uma consulta SQL que forneça um resumo das avaliações das 
hospedagens por cidade, incluindo a média das notas de avaliação e o número total de avaliações. 
Além disso, para facilitar a leitura do relatório pela equipe de gerenciamento, as cidades 
devem ser apresentadas em letras maiúsculas.*/

/*Estruturas relevantes das tabelas
Tabela de Hospedagens: Contém hospedagem_id, tipo, e endereco_id.
Tabela de Avaliações: Contém avaliacao_id, cliente_id, hospedagem_id, nota, e comentario.
Tabela de Endereços: Contém endereco_id, cidade.*/


SELECT ROUND(AVG(a.nota),2) AS Media_notas_Avaliacao, COUNT(a.avaliacao_id) AS Total_Avaliacoes, UPPER(e.cidade) AS Cidade FROM Avaliacoes a
JOIN Hospedagem h ON h.hospedagem_id = a.hospedagem_id
JOIN Enderecos e ON e.enderecos_id = h.enderecos_id
GROUP BY e.cidade
ORDER BY hMedia_notas_Avaliacao DESC, Total_Avaliacoes DESC;

/********************************************************************************************/

/*Durante o nosso percurso, conhecemos algumas funções que podem ser utilizadas para 
manipular os nossos dados. Uma dessas funções é a CASE, que é utilizada para categorizar 
dados através de condições, como no exemplo abaixo:

SELECT hospedagem_id, nota,
CASE nota
        WHEN  5 THEN 'Excelente'
        WHEN  4 THEN 'Ótimo'
        WHEN  3 THEN 'Muito Bom'
        WHEN  2 THEN 'Bom'
        ELSE 'Ruim'
END AS StatusNota
FROM avaliacoes;
*/

/*Nesta consulta, estamos categorizando as notas dadas pelos clientes ao avaliar uma hospedagem.

Utilizando a consulta criada em aula, e apresentada anteriormente, 
traga a quantidade de registros existentes em cada categoria: 
'Excelente', 'Ótimo', 'Muito Bom', 'Bom' e 'Ruim'.
*/

SELECT CASE nota
	WHEN 5 THEN 'Excelente'
	WHEN 4 THEN 'Ótima'    
    WHEN 3 THEN 'Muito Boa'    
    WHEN 2 THEN 'Boa'
    ELSE 'Ruim'
END AS StatusNota, COUNT(*) AS Qtd FROM avaliacoes
GROUP BY StatusNota
ORDER BY Qtd DESC;