/**
PROBLEM: 2998 - The Payback
RANKING: 00211th
URL: https://www.beecrowd.com.br/judge/en/problems/view/2998
ANSWER: Accepted
LANGUAGE: PostgreSQL (psql 9.4.19)
RUNTIME: 0.009s
FILE SIZE: 1.52 KB
MEMORY: -
SUBMISSION: 1/26/23, 5:52:29 PM
 */
WITH cte1 AS( 
SELECT clients.id, clients.investment, 
	SUM(operations.profit) - clients.investment AS net_value FROM clients
	INNER JOIN operations 
	ON operations.client_id = clients.id
	GROUP BY clients.id
),
cte2 AS(
	SELECT clients.name, cte1.* 
	FROM cte1 
	INNER JOIN clients 
	ON clients.id = cte1.id
	WHERE cte1.net_value >= 0
),
cte3 AS (
	SELECT cte2.*, 
	operations.month, 
	operations.profit FROM cte2
	INNER JOIN operations 
	ON operations.client_id = cte2.id
),
cte_user_2 AS(
SELECT * 
	FROM cte3 
	WHERE cte3.id = 2
	
),
cte_user_22 AS (
SELECT *, 
		SUM(cte_user_2.profit) 
		OVER (ORDER BY cte_user_2.month) AS cummulative 
		FROM cte_user_2
),
cte_user_3 AS(
SELECT * 
	FROM cte3 
	WHERE cte3.id = 3
	
),
cte_user_33 AS (
SELECT *, 
	   	SUM(cte_user_3.profit) OVER (ORDER BY cte_user_3.month) AS cummulative 
		FROM cte_user_3
), 
cte_final AS (
(SELECT cte_user_22.name, cte_user_22.investment,
cte_user_22.month AS month_of_payback, 
cte_user_22.cummulative - cte_user_22.investment AS return
FROM cte_user_22
WHERE cte_user_22.cummulative >= cte_user_22.investment
LIMIT 1)
UNION ALL
(SELECT cte_user_33.name, cte_user_33.investment,
cte_user_33.month AS month_of_payback, 
cte_user_33.cummulative - cte_user_33.investment AS return
FROM cte_user_33
WHERE cte_user_33.cummulative >= cte_user_33.investment
LIMIT 1)
)
SELECT * FROM cte_final ORDER BY cte_final.return DESC