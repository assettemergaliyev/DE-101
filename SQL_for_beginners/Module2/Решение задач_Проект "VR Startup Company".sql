--Создание схем мr_startup
CREATE SCHEMA IF NOT EXISTS vr_startup;

--Как зовут сотрудников, которые не выбрали проект?
SELECT
	first_name,
	last_name
FROM
	vr_startup.employees
WHERE
	current_project IS NULL;
	
--Как называются проекты, которые не выбраны никем из сотрудников?
SELECT
	p.project_name
FROM
	vr_startup.projects AS p
WHERE
	p.project_id
		NOT IN
			(SELECT
				e.current_project
			FROM
				vr_startup.employees AS e
			WHERE
				e.current_project IS NOT NULL);

--Какой проект выбирают большинство сотрудников (укажите название)?
SELECT
	p.project_name,
	COUNT(e.employee_id)
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
	 ON p.project_id = e.current_project
GROUP BY
	p.project_name
ORDER BY
	COUNT(e.employee_id) DESC;
	
--Какие проекты выбрали несколько сотрудников (то есть больше 1)?
SELECT
	p.project_name,
	COUNT(e.employee_id)
FROM
	vr_startup.employees AS e
JOIN
	vr_startup.projects AS p
		ON e.current_project = p.project_id
GROUP BY
	p.project_name
HAVING
	COUNT(e.employee_id) > 1;
	
--На каждый проект нужно как минимум 2 разработчика. Сколько доступных проектных позиций для разработчика?
--Достаточно ли у нас разработчиков для заполнения необходимых вакансий?

SELECT
	COUNT(*)
FROM
	vr_startup.employees AS e
WHERE
	e.position = 'Developer'
	AND
	e.current_project IS NULL;
---
SELECT
	COUNT(*)
FROM
	vr_startup.projects;
	
--Какая личность наиболее характерна для наших сотрудников?
SELECT
	personality
FROM
	vr_startup.employees
GROUP BY
	personality
ORDER BY
	COUNT(*) DESC
LIMIT
	1;
	
--Какие названия проектов выбирают сотрудники с наиболее распространенным типом личности?
SELECT
	p.project_name
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
		ON p.project_id = e.current_project
WHERE
	e.personality = (SELECT
						personality
					FROM
						vr_startup.employees
					GROUP BY
						personality
					ORDER BY
						COUNT(*) DESC
					LIMIT
						1);

--Найдите тип личности, наиболее представленный сотрудниками с выбранным проектом;
--Как зовут этих сотрудников, тип личности и названия проекта, который они выбрали?

SELECT
	e.first_name,
	e.last_name,
	e.personality,
	p.project_name
FROM
	vr_startup.projects AS p
JOIN
	vr_startup.employees AS e
		ON p.project_id = e.current_project
WHERE
	e.personality = (SELECT
						personality
					FROM
						vr_startup.employees AS e
					WHERE
					 	e.current_project IS NOT NULL
					GROUP BY
						e.personality
					ORDER BY
						COUNT(e.personality) DESC
					LIMIT
						1);

--Для каждого сотрудника укажите его имя, личность, названия любых выбранных ими проектов
--и количество несовместимых сотрудников.
SELECT
	e.first_name,
	e.last_name,
	e.personality,
	p.project_name,	
	CASE
		WHEN e.personality IN ('INFP', 'ENFP', 'INFJ') THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
		WHEN  e.personality = 'ENFJ' THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
		WHEN  e.personality = 'ISFP' THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('INFP', 'ENFP', 'INFJ'))  
		WHEN  e.personality IN ('ESFP', 'IESTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ') THEN (SELECT COUNT(*) FROM vr_startup.employees AS e WHERE e.personality IN ('INFP', 'ENFP', 'INFJ', 'ENFJ'))
		ELSE 0
	END AS imcompats
FROM
	vr_startup.employees AS e
LEFT JOIN
	vr_startup.projects AS p
		ON p.project_id = e.current_project;

	