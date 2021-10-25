--Проект Songify. Вывести пользователей с премиум подпиской и их описанием

SELECT
	pu.user_id,
	sp.description
FROM
	songify.premium_users AS pu
INNER JOIN
	songify.plans AS sp
		ON sp.id = pu.membership_plan_id;

--Вывести название песен, которые слушает каждый пользователь

SELECT
	p.user_id,
	p.play_date,
	s.title
FROM
	songify.plays AS p
INNER JOIN
	songify.songs AS s
		ON s.id = p.song_id;
		
--Какие пользователи не являются премиум-пользователями?

SELECT
	u.id
FROM
	songify.users AS u
LEFT JOIN
	songify.premium_users AS pu
		ON u.id = pu.user_id
WHERE
	pu.user_id IS NULL;
	
--С помощью CTE найдите пользователей, которые слушали музыку в январе и феврале, а потом оставьте
--только тех пользователей, которые слушали музыку ТОЛЬКО в январе.

WITH january AS
	(SELECT
		*
	FROM
		songify.plays
	WHERE
	 	EXTRACT(MONTH FROM play_date) = 1),
february AS	 
	(SELECT
		*
	FROM
		songify.plays
	WHERE
	 	EXTRACT(MONTH FROM play_date) = 2)
SELECT
	j.user_id
FROM
	january AS j
LEFT JOIN
	february AS f
		ON j.user_id = f.user_id
WHERE
	f.user_id IS NULL;
	
--Для каждого месяца в таблице months мы хотим знать, был ли каждый премиум-пользователь
--активным или удаленным (не продлевал свою подписку на сервис)

SELECT
	pu.user_id,
	pu.purchase_date::date AS purchase_date,
	pu.cancel_date::date AS cancel_date,
	m.months::date
FROM
	songify.premium_users AS pu
CROSS JOIN
	songify.months AS m;
	
--Определите какие пользователи у нас активные, а какие неактивные в каждом месяце

SELECT
	pu.user_id,
	pu.purchase_date::date AS purchase_date,
	pu.cancel_date::date AS cancel_date,
	m.months::date,
	CASE
		WHEN(pu.purchase_date <= m.months)
			AND
			(pu.cancel_date >= m.months OR pu.cancel_date IS NULL)
		THEN 'active'
		ELSE 'not_active'
	END AS status
FROM
	songify.premium_users AS pu
CROSS JOIN
	songify.months AS m;
	
--Объедините таблицу songs и bonus_songs с помощью UNION и выберите все столбцы.
--Поскольку таблица songs очень большая, просто посмотрите на некий срез данных
--и выведите только 10 строк с помощью LIMIT.

SELECT
	*
FROM
	songify.songs
UNION
SELECT
	*
FROM
	songify.bonus_songs
LIMIT
	10;
	
--Найти количество раз, которое была прослушана каждая песня

SELECT
	p.song_id,
	s.title,
	COUNT(p.song_id) AS "times_played"
FROM
	songify.songs AS s
INNER JOIN
	songify.plays AS p
		ON s.id = p.song_id
GROUP BY
	s.title,
	p.song_id
ORDER BY
	times_played DESC