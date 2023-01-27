/**
PROBLEM: 2995 - The Sensor Message
RANKING: 00615th
URL: https://www.beecrowd.com.br/judge/en/problems/view/2995
ANSWER: Accepted
LANGUAGE: PostgreSQL (psql 9.4.19)
RUNTIME: 0.004s
FILE SIZE: 251 Bytes
MEMORY: -
SUBMISSION: 1/24/23, 9:30:31 PM
 */
SELECT SUM(records.temperature)/COUNT(*) AS "temperature", COUNT(*) AS "number_of_records" FROM records
GROUP BY records.mark
ORDER BY records.mark