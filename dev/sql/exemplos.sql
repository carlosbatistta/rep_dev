
-- Exemplo de uso do CASE, WHEN e ELSE em SQL
SELECT 
  id_cliente,
  SUM(CASE WHEN tipo = 'credito' THEN valor ELSE 0 END) AS total_credito,
  SUM(CASE WHEN tipo = 'debito' THEN valor ELSE 0 END) AS total_debito,
  SUM(CASE 
        WHEN tipo = 'credito' THEN valor 
        WHEN tipo = 'debito' THEN -valor 
        ELSE 0 
      END) AS saldo_final
FROM vendas
GROUP BY id_cliente;

-- Exemplo de uso no innerjoin em SQL
SELECT 
    pedidos.id,
    clientes.nome,
    pedidos.valor_total
FROM pedidos
INNER JOIN clientes ON pedidos.cliente_id = clientes.id;

-- Exemplo de uso do HAVING onde o valor total dos pedidos é maior que 1000
SELECT 
    cliente_id,
    SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
HAVING SUM(valor_total) > 1000;

--ROW_NUMBER(): numera os funcionários em cada departamento, do maior para o menor salário.
SELECT 
    nome,
    departamento,
    ROW_NUMBER() OVER (PARTITION BY departamento ORDER BY salario DESC) AS posicao
FROM funcionarios;

-- RANK(): numera os funcionários em cada departamento, do maior para o menor salário, mas atribui o mesmo número para salários iguais.
SELECT 
    nome,
    departamento,
    RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) AS posicao

-- SUBQUERY: retorna os nomes dos clientes que fizeram pedidos com valor total maior que 1000.
SELECT nome
FROM clientes
WHERE id IN (
    SELECT cliente_id
    FROM pedidos
    WHERE valor_total > 1000
);

--WITH (CTE): retorna os clientes que fizeram pedidos com valor total maior que 1000, e a quantidade de pedidos feitos por cada cliente.
WITH pedidos_valiosos AS (
    SELECT cliente_id, valor_total
    FROM pedidos
    WHERE valor_total > 1000
)
SELECT cliente_id, COUNT(*) AS qtde_pedidos
FROM pedidos_valiosos
GROUP BY cliente_id;

--Retornar os ultimos 30 dias de cadastro
SELECT nome, cidade 
FROM clientes 
WHERE data_cadastro >= current_date - INTERVAL '30 days'
ORDER BY data_cadastro DESC;
