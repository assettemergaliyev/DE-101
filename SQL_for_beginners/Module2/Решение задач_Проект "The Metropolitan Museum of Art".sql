--Создание схемы metropolitan
CREATE SCHEMA IF NOT EXISTS metropolitan;

--Вывести первые 10 записей таблицы met из схемы metropolitan
SELECT
	*
FROM
	metropolitan.met
LIMIT
	10;
	
--Сколько произведений в коллекции американского декоративного искусства?
SELECT
	department,
	COUNT(id)
FROM
	metropolitan.met
WHERE
	department = 'American Decorative Arts'
GROUP BY
	department;

--Подсчитайте количество произведений искусства, в которых в category содержится слово 'celery' (сельдерей)
SELECT
	COUNT(*)
FROM
	metropolitan.met
WHERE
	category ILIKE '%celery%';
	
--Подсчитайте количество уникальных категорий произведений искусства, в которых в category содержится слово 'celery' (сельдерей)
SELECT
	DISTINCT category
FROM
	metropolitan.met
WHERE
	category ILIKE '%celery%';

--Выведите title и medium самых старых произведений искусств в коллекциях
SELECT
	title,
	medium,
	date
FROM
	metropolitan.met
WHERE
	date LIKE '%1600%';
	
--Найдите 10 стран с наибольшим количеством предметов в коллекции
SELECT
	country,
	COUNT(title) AS collections
FROM
	metropolitan.met
WHERE 
	country IS NOT NULL
GROUP BY
	country
ORDER BY
	collections DESC
LIMIT
	10;
	
--Найдите категории, в которых больше 100 произведений искусства
SELECT
	category,
	COUNT(*)
FROM
	metropolitan.met
GROUP BY
	category
HAVING
	COUNT(*) > 100
ORDER BY
	2 DESC;
	
--Посчитаем количество произведений искусства, которые сделаны из золота или серебра
--Выведем также сам материал

SELECT
	medium,
	COUNT(*)
FROM
	metropolitan.met
WHERE
	medium ILIKE '%gold%'
		OR
	medium ILIKE '%silver%'
GROUP BY
	medium
ORDER BY
	2 DESC;
	
---

WITH gold_silver AS
	(SELECT
		CASE
			WHEN medium ILIKE '%gold%' THEN 'Gold'
			WHEN medium ILIKE '%silver%' THEN 'Silver'
			ELSE NULL
		END AS Bling,
		COUNT(*)
	FROM
		metropolitan.met
	GROUP BY
		1
	ORDER BY
		2 DESC)
SELECT
	*
FROM
	gold_silver
WHERE
	bling IS NOT NULL;
