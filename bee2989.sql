/**
PROBLEM: 2989 - Departments and Divisions
RANKING: 00175th
ANSWER: Accepted
LANGUAGE: PostgreSQL (psql 9.4.19)
RUNTIME: 0.013s
FILE SIZE: 1.59 KB
MEMORY: -
SUBMISSION: 1/25/23, 3:42:42 PM
 */
WITH RECURSIVE
func_venc_desc AS(
SELECT  emp_venc.matr AS matricula,SUM(vencimento.valor) AS valor FROM  emp_venc
INNER JOIN vencimento ON emp_venc.cod_venc = vencimento.cod_venc
GROUP BY emp_venc.matr 
UNION ALL
SELECT  emp_desc.matr AS matricula, -SUM(COALESCE(desconto.valor,0)) AS valor  FROM  emp_desc
INNER JOIN desconto ON desconto.cod_desc = emp_desc.cod_desc
GROUP BY emp_desc.matr),
salario_liquido AS ( SELECT  func_venc_desc.matricula as matr, 
					SUM(func_venc_desc.valor) AS sal_lqd 
					FROM func_venc_desc 
					GROUP BY func_venc_desc.matricula),
depto_funcionario AS (SELECT departamento.nome, 
					  empregado.matr,
					  empregado.lotacao_div
					  FROM empregado 
					  INNER JOIN  departamento
					  ON departamento.cod_dep = empregado.lotacao
),
divisao_funcionario AS ( SELECT depto_funcionario.nome AS depto_nome, 
								divisao.nome AS divisao_nome, 
								depto_funcionario.matr  
						FROM  depto_funcionario 
						INNER JOIN divisao
						ON depto_funcionario.lotacao_div = divisao.cod_divisao
) 
SELECT 	divisao_funcionario.depto_nome, divisao_funcionario.divisao_nome AS divisao,
	    ROUND(AVG(COALESCE(salario_liquido.sal_lqd,0))::numeric,2) AS media,
        MAX(COALESCE(salario_liquido.sal_lqd,0))::numeric(10,2) AS maior
		FROM divisao_funcionario 
		LEFT JOIN salario_liquido ON
	    salario_liquido.matr = divisao_funcionario.matr
	    GROUP BY divisao_funcionario.divisao_nome,divisao_funcionario.depto_nome
	    ORDER BY media DESC 