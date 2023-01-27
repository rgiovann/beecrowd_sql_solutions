/**
PROBLEM: 2996 - Package Delivery
RANKING: 00477th
URL: https://www.beecrowd.com.br/judge/en/problems/view/2996
ANSWER: Accepted
LANGUAGE: PostgreSQL (psql 9.4.19)
RUNTIME: 0.005s
FILE SIZE: 1.23 KB
MEMORY: -
SUBMISSION: 1/25/23, 2:16:43 PM
 */
 WITH 
dados_sender AS (
 SELECT packages.year AS year_sent,
	 packages.color AS color_package, 
	 packages.id_user_receiver AS receiver_id, 
	 users.name AS name_sender,
	 users.address AS pack_address_sender 
	 FROM users 
	 INNER JOIN packages 
	 ON packages.id_user_sender = users.id
 ),
dados_receiver AS
(SELECT dados_sender.year_sent AS year_final, 
 dados_sender.color_package AS color_final,
 dados_sender.name_sender AS sender_name_final,
 users.name AS receiver_name_final,
 dados_sender.pack_address_sender AS pack_address_sender_final, 
 users.address AS pack_address_receiver_final 
 FROM users 
 INNER JOIN dados_sender 
 ON dados_sender.receiver_id = users.id
)
SELECT dados_receiver.year_final AS year, 
        dados_receiver.sender_name_final AS sender, 
		dados_receiver.receiver_name_final AS receiver 
		FROM dados_receiver
WHERE (dados_receiver.color_final ='blue' OR dados_receiver.year_final = 2015 ) AND dados_receiver.pack_address_sender_final != 'Taiwan' AND dados_receiver.pack_address_receiver_final !='Taiwan'
ORDER BY dados_receiver.year_final DESC,dados_receiver.pack_address_sender_final DESC
