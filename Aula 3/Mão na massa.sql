/*Mão na massa: explorando a ocupação de hospedagens*/

/*Em uma plataforma de aluguel de curto prazo, entender a ocupação atual das hospedagens disponíveis 
é essencial para gerenciar efetivamente as propriedades e otimizar as taxas de ocupação. 
Como parte do esforço contínuo para melhorar a análise de dados e a tomada de decisão, a 
empresa busca implementar uma função no MySQL que calcule a ocupação média das hospedagens. 
Esta métrica ajudará a equipe de gestão a avaliar o desempenho das propriedades em sua plataforma.*/

/*Desafio: Como pessoa desenvolvedora da equipe, você recebeu a responsabilidade de criar uma 
função no MySQL para determinar a ocupação média das hospedagens.A função deve calcular a média
de hospedagens ocupadas em relação ao total de hospedagens listadas. Para simplificar, 
assuma que cada registro na tabela de alugueis representa uma ocupação e que o total de 
registros na tabela de hospedagens representa o número total de hospedagens disponíveis.*/


DELIMITER $$
 
CREATE FUNCTION ocupacao()
RETURNS DECIMAL(5,2) DETERMINISTIC

BEGIN

	DECLARE total_alugueis INT;
    DECLARE total_hospedagem INT;
    DECLARE taxa_ocupacao DECIMAL(10,2);
    
	-- Número de hospedagens ocupadas 
	SELECT COUNT(*) INTO total_alugueis FROM alugueis;
    
    -- Número de hospedagens listadas
    SELECT COUNT(*) INTO total_hospedagem FROM hospedagens;
	
    SET taxa_ocupacao = (total_alugueis / total_hospedagem )* 100;
	
    RETURN taxa_ocupacao;
    
END$$
DELIMITER ;
 
 SELECT ocupacao();
 
/************************************************************************************/

/*Mão na massa: desvendando as preferências dos hóspede*/

/*Para melhor entender as preferências dos hóspedes e otimizar a oferta de hospedagens,os 
gestores da insightplaces desejam analisar quais tipos de hospedagem são mais populares.Sua 
missão é criar uma função no MySQL que conte o número de hospedagens disponíveis por tipo.*/

/*Desafio: Como pessoa desenvolvedora, você precisa criar uma função no MySQL que receba 
como parâmetro um tipo de hospedagem (por exemplo, 'Casa', 'Apartamento', 'Hotel') e retorne
o total de hospedagens disponíveis desse tipo. Esta função ajudará a equipe a entender 
rapidamente a distribuição das acomodações na plataforma.*/



DROP FUNCTION IF EXISTS busca_hospedagem_tipo;

DELIMITER $$

CREATE FUNCTION busca_hospedagem_tipo(tipo_hospedagem VARCHAR(50))
RETURNS INTEGER DETERMINISTIC

BEGIN
	DECLARE contador_tipo INT;
	
    SELECT COUNT(tipo) INTO contador_tipo FROM hospedagens
	WHERE tipo_hospedagem LIKE tipo;

	RETURN contador_tipo;
	
END $$

DELIMITER ;

SELECT busca_hospedagem_tipo('Casa');
SELECT busca_hospedagem_tipo('Hotel');
SELECT busca_hospedagem_tipo('Apartamento');

SELECT COUNT(*) FROM hospedagens
WHERE tipo LIKE 'Apartamento';
