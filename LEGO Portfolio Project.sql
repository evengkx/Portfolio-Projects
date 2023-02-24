-- Creating a view for easy querying

CREATE VIEW analytics_main AS
SELECT s.set_num AS set_name, s.name, s.year, s.theme_id, CAST(s.num_parts AS numeric) as num_parts, 
t.name AS theme_name, t.parent_id, p.name AS parent_theme_name
FROM sets AS s
LEFT JOIN themes AS t
	ON s.theme_id = t.id
LEFT JOIN themes AS p
	ON t.parent_id = p.id

SELECT * FROM analytics_main

-- 1. What is the total number of parts per theme?
-- Includes/excludes NULL parent themes

SELECT theme_name, SUM(num_parts) AS total_num_parts
FROM analytics_main
--WHERE parent_theme_name IS NOT NULL
GROUP BY theme_name
ORDER BY 2 DESC

-- 2. What is the total number of parts per year?

SELECT year, SUM(num_parts) AS total_num_parts
FROM analytics_main
WHERE parent_theme_name IS NOT NULL
GROUP BY year
ORDER BY 2 DESC

-- 3. How many sets were created in each century in the dataset?

SELECT COUNT(set_name) AS total_num_set, Century
FROM analytics_main
--WHERE parent_theme_name IS NOT NULL
GROUP BY Century

-- 4. What percentage of sets ever released in the 21st Century were Trains theme?

;WITH CTE AS
(
	SELECT COUNT(set_num) AS total_set_num, theme_name, Century
	FROM analytics_main
	WHERE Century = '21st Century'
	GROUP BY Century, theme_name
)
SELECT SUM(total_set_num), SUM(percentage)
FROM(
	SELECT Century, theme_name, total_set_num, SUM(total_set_num) OVER () AS total, 
	CAST(1.00 * total_set_num / SUM(total_set_num) OVER () AS decimal(5,4)) * 100 AS percentage
	FROM CTE
	)m
WHERE theme_name LIKE '%train%'

-- 5. What was the popular theme by year in terms of sets released in the 21st Century?

SELECT year, theme_name, total_set_num
FROM(
	SELECT year, theme_name, COUNT(set_num) AS total_set_num, 
	ROW_NUMBER() OVER (PARTITION BY year ORDER BY COUNT(set_num) DESC) AS rn
	FROM analytics_main
	WHERE Century = '21st Century'
	AND parent_theme_name IS NOT NULL
	GROUP BY year, theme_name
	)m
WHERE rn = 1
ORDER BY year DESC

-- 6. What is the most produced color of lego ever in terms of quantity of parts?

SELECT color_name, SUM(quantity) AS quantity_of_parts
FROM(
	SELECT inv.color_id, inv.inventory_id, inv.part_num, CAST(inv.quantity AS numeric) AS quantity,
	inv.is_spare, c.name AS color_name, c.rgb, p.name AS part_name, p.part_material AS category_name
	FROM inventory_parts AS inv
	INNER JOIN colors AS c
		ON inv.color_id = c.id
	INNER JOIN parts AS p
		ON inv.part_num = p.part_num
	INNER JOIN part_categories AS pc
		ON part_cat_id = pc.id
	) AS main
GROUP BY color_name
ORDER BY 2 DESC