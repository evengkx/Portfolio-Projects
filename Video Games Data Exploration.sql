-- 1. Different RE Games, Their Platforms and Release Years
SELECT g.game_name, pl.platform_name, gp.release_year
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE game_name LIKE 'Resident Evil%'
GROUP BY g.game_name, pl.platform_name, gp.release_year
ORDER BY gp.release_year

-- 2. All RE Games Based on Global Sales
SELECT g.game_name, gp.release_year, pl.platform_name, 
r.region_name, SUM(rs.num_sales) AS global_sales
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE game_name LIKE 'Resident Evil%'
GROUP BY g.game_name, gp.release_year, pl.platform_name, r.region_name
ORDER BY SUM(rs.num_sales) DESC

-- 3. Top 20 Shooter Games Based on Global Sales
SELECT TOP 20 g.game_name, gp.release_year, pl.platform_name, 
SUM(rs.num_sales) AS global_sales
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.genre AS genre
	ON g.genre_id = genre.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE genre_name = 'Shooter'
GROUP BY g.game_name, gp.release_year, pl.platform_name
ORDER BY SUM(rs.num_sales) DESC

-- 4. Top 10 Games Released by Nintendo
SELECT TOP 10 g.game_name, gp.release_year, pub.publisher_name, pl.platform_name, 
SUM(rs.num_sales) AS global_sales
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.genre AS genre
	ON g.genre_id = genre.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE publisher_name = 'Nintendo'
GROUP BY g.game_name, gp.release_year, pub.publisher_name, pl.platform_name
ORDER BY SUM(rs.num_sales) DESC

-- 5. Top 10 Games for PC
SELECT TOP 10 g.game_name, gp.release_year, pub.publisher_name, pl.platform_name, 
SUM(rs.num_sales) AS global_sales
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.genre AS genre
	ON g.genre_id = genre.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE platform_name = 'PC'
GROUP BY g.game_name, gp.release_year, pub.publisher_name, pl.platform_name
ORDER BY SUM(rs.num_sales) DESC

-- 6. Top 10 Best-Seller Games in 1995
SELECT TOP 10 g.game_name, gp.release_year, pub.publisher_name, pl.platform_name, 
SUM(rs.num_sales) AS global_sales
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.genre AS genre
	ON g.genre_id = genre.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE release_year = '1995'
GROUP BY g.game_name, gp.release_year, pub.publisher_name, pl.platform_name
ORDER BY SUM(rs.num_sales) DESC

-- 7. Top 10 Best-Seller Games in 1995 in Japan
SELECT TOP 10 g.game_name, gp.release_year, r.region_name,
pub.publisher_name, pl.platform_name, SUM(rs.num_sales) AS global_sales
FROM video_games.dbo.region_sales AS rs
INNER JOIN video_games.dbo.region AS r 
	ON rs.region_id = r.id
INNER JOIN video_games.dbo.game_platform AS gp 
	ON rs.game_platform_id = gp.id
INNER JOIN video_games.dbo.game_publisher AS gpub 
	ON gp.game_publisher_id = gpub.id
INNER JOIN video_games.dbo.game AS g 
	ON gpub.game_id = g.id
INNER JOIN video_games.dbo.genre AS genre
	ON g.genre_id = genre.id
INNER JOIN video_games.dbo.platform AS pl 
	ON gp.platform_id = pl.id
INNER JOIN video_games.dbo.publisher AS pub 
	ON gpub.publisher_id = pub.id
WHERE region_name = 'Japan'
GROUP BY g.game_name, gp.release_year, r.region_name,
pub.publisher_name, pl.platform_name
ORDER BY SUM(rs.num_sales) DESC