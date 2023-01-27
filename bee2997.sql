/**
PROBLEM: 2997 - Employees Payment
RANKING: 00033th
URL: https://www.beecrowd.com.br/judge/en/problems/view/2997
ANSWER: Accepted
LANGUAGE: PostgreSQL (psql 9.4.19)
RUNTIME: 0.004s
FILE SIZE: 1.49 KB
MEMORY: -
SUBMISSION: 1/25/23, 6:32:29 PM
 */
WITH
func_venc AS(
	SELECT  emp_venc.matr,
	    	SUM(vencimento.valor) AS valor 
	FROM  emp_venc
	RIGHT JOIN vencimento 
	ON emp_venc.cod_venc = vencimento.cod_venc
	GROUP BY emp_venc.matr 
),
func_venc_bruto AS(
	SELECT  empregado.nome,
			empregado.matr,
			empregado.lotacao AS lotacao,
	COALESCE(func_venc.valor,0)  AS valor
	FROM  func_venc
	RIGHT JOIN empregado 
	ON empregado.matr = func_venc.matr
),
func_desc AS (
	SELECT  emp_desc.matr, 
	SUM(COALESCE(desconto.valor,0)) AS valor  
	FROM  emp_desc
	INNER JOIN desconto 
	ON desconto.cod_desc = emp_desc.cod_desc
	GROUP BY emp_desc.matr),
func_desc_bruto AS (
	SELECT  empregado.matr,
	COALESCE(func_desc.valor,0) AS valor
	FROM  func_desc
	RIGHT JOIN empregado ON empregado.matr = func_desc.matr
),
cte1 AS (
	SELECT func_venc_bruto.nome,
	func_venc_bruto.lotacao,
	func_venc_bruto.valor  AS sal_bruto, 
	func_desc_bruto.valor  AS descontos, 
	(func_venc_bruto.valor - func_desc_bruto.valor)  AS sal_liq 
	FROM func_venc_bruto
	INNER JOIN func_desc_bruto 
	ON func_desc_bruto.matr = func_venc_bruto.matr
)
SELECT 	departamento.nome AS "Departamento", 
 		cte1.nome AS "Empregado", 
		cte1.sal_bruto "Salario Bruto", 
		cte1.descontos "Total Desconto", 
		cte1.sal_liq "Salario Liquido"
		FROM cte1
		INNER JOIN departamento
		ON departamento.cod_dep = cte1.lotacao
		ORDER BY cte1.sal_liq DESC,cte1.nome DESC