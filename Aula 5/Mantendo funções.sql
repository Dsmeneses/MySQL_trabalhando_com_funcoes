/*Mantendo Funções*/

/*Controle de Erros*/

/*Quando começamos a estudar funções, não abordamos cursores, loops while ou tratamento de erros, 
porque esses recursos não foram concebidos para serem utilizados junto com funções. 
As funções são projetadas para serem simples, como as funções nativas da linguagem SQL.

Por exemplo, a função de agregação sum recebe um valor, realiza a soma e retorna um valor único. 
Da mesma forma, a função que criamos pode receber um parâmetro, executar uma ação e retornar 
um único valor. Esse é o propósito das funções.*/

-- Distinção entre Funções e procedures

/*Internamente, as funções e as procedures no MySQL são tratadas de formas diferentes. 
As procedures têm realmente o objetivo de ser mais robustas, já as funções são realmente bem 
mais simples. Recebem um valor ou não, executam algo e retornam para quem as executou.

Dentro dos procedimentos armazenados, podemos lidar com erros, utilizar cursores, e empregar 
loopings, entre outras funcionalidades. É possível, em alguns casos, aplicar loopings ou 
cursores dentro de funções, mas isso não é sua finalidade principal, já que as funções são 
concebidas para serem simples.*/

-- Objetivo da Função: Ser simples
-- Objetivo da Procedure: Ser mais robusta

-- Determinismo nas Funções

/*Por exemplo, ao definirmos que uma função é determinística, estamos estabelecendo que, 
para um conjunto específico de parâmetros, ela sempre produzirá o mesmo resultado.
Se optarmos por trabalhar com funções que executam inserções (insert), embora essa não seja a
melhor abordagem, pode haver situações em que trabalhar com inserção, atualização e exclusão
nem seja viável. Sabemos que podemos realizar inserções ao incorporá-las dentro de uma função, 
especialmente devido ao tratamento de erros que isso possibilita. 
Isso tornaria a função mais robusta, se fosse factível.*/

/*Determinismo: Funções precisam ser determinísticas (ou ao menos, quando marcadas como tal),
significando que devem retornar o mesmo resultado sempre que são chamadas com um conjunto 
específico de parâmetros de entrada, dentro do mesmo estado do banco de dados.*/


-- O que acontece se passarmos um valor que não existe na tabela para uma função??

-- Passando o valor de id_aluguel (0)

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

-- Retorna um NULL, porém é possível retornar uma mensagem para que seja explicado que não
-- existe o valor passado como parâmetro.
SELECT calcula_ValorFInal_com_desconto(0);

/************************************************************************************/

/*Modificando funções*/

-- Modificando uma função para alterar o retorno dela, desta forma, ela não retornará mais NULL

-- O IF verifica se a quantidade de dias é igual a 0, menor que 0 ou se é nulo, caso seja, 
-- o valor de retorno é 0, substituindo o NULL de antes.
-- Caso a quantidade de dias seja válida as atribuições são feitas normalmente.

 IF dias IS NULL OR dias <=0 THEN
		RETURN 0;
ELSE    
		SET valor_diaria = preco_total / dias;
		SET resultado = CONCAT('Nome: ', nome_cliente, ', Valor Diário: R$', FORMAT(valor_diaria,2));
END IF;

-- Dessa forma, o retorno dessa chamada deixa de ser NULL e passa a ser 0.
SELECT info_aluguel(0);


/************************************************************************************/


/*Excluindo funções*/

-- Vamos supor que agora excluiremos a função CalcularValorFinalComDesconto.
-- Para fazer isso, executaremos o comando de exclusão da função, 
-- que é DROP FUNCTION IF EXISTS CalcularValorFinalComDesconto;.

DROP FUNCTION IF EXISTS CalcularValorFinalComDesconto;

-- Depois de excluída, ao tentarmos usar essa função em um select, receberemos um erro 
-- indicando que a função não está mais disponível.

SELECT CalcularValorFinalComDesconto(0);

-- Executamos o comando select e obtemos:
-- ErrorCode: 1305. FUNCTION insightplaces CalcularValorFinalComDesconto does not exist


-- Um problema maior ocorre quando vamos inserir alguns valores, porque essa função é chamada dentro
-- da TRIGGER.

INSERT INTO alugueis (alugel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total)
VALUES (10002, 35, 20, '2024-01-09', '2024-01-12', 2000.00);

/* Estamos inserindo em alugueis um novo alugel_id, cliente_id, hospedagem_id, data_inicio, 
data_fim, preco_total. Selecionamos o comando e executamos para inserir essas informações.
Ao analisarmos no retorno, conseguimos inserir sem nenhum erro.*/

/*Ao validar a nossa tabela resumo_aluguel, temos a inserção dos valores:*/
SELECT * FROM resumo_aluguel;

/*No entanto, observamos que o desconto aplicado e o valor final não foram inseridos.
Isso ocorre porque a função que calcula estes valores foi excluída. Portanto, precisamos ter 
muito cuidado, pois ao remover essa função, podemos acabar perdendo muitas informações que são
importantes.*/