CREATE TABLE netflix
(
	show_id	VARCHAR(100),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;

-- Counting the total rows
select 
     count(*) as total_content 
from netflix;

-- Displaying the unique type 
SELECT 
    DISTINCT TYPE
FROM netflix;

-- 15 Business Problem

--1. Count the number of Movies vs TV Shows

SELECT 
     type,
	 count(*) as Total_Content
from netflix
group by type;

--2. Find the most common rating for movies and TV shows

SELECT type,
       rating
FROM
(
SELECT 
    type,
	rating,
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as Ranking
From netflix
GROUP BY type,rating
) as t1
where ranking = 1;
 
--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
WHERE
     type = 'Movie'
	 AND
	 release_year = 2020;


--4. Find the top 5 countries with the most content on Netflix

SELECT 
     UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	 COUNT(show_id) as Total_Content
FROM netflix
GROUP BY country
ORDER BY total_content desc limit 5 ;

--5. Identify the longest movie
SELECT * FROM netflix
WHERE
    type = 'Movie'
	AND
	duration = (SELECT max(duration) FROM netflix)

--6. Find content added in the last 5 years

SELECT * FROM netflix 
WHERE  
    TO_DATE(date_added,'Month DD , YYYY')  >= CURRENT_DATE - INTERVAL '5 years'


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT type,
       title,
	   director
FROM netflix
WHERE director ILIKE  '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE  type = 'TV Show'
       AND 
       SPLIT_PART(duration,' ',1)::numeric > 5;
	   

--9. Count the number of content items in each genre

SELECT 
       UNNEST(STRING_TO_ARRAY(listed_in,',')) as Genre,
       COUNT(show_id) as Total_Content
FROM netflix
GROUP BY listed_in;

/*10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!*/

SELECT
     EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	 COUNT(*) yearly_content,
	 ROUND(
     COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	 ,2) as Avg_content_Per_Year
FROM netflix
WHERE country = 'India'
GROUP By 1;

--11. List all movies that are documentaries

SELECT  * FROM netflix
WHERE
    listed_in ILIKE '%documentaries%'

--12. Find all content without a director

SELECT * FROM netflix
WHERE 
   director is NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
     casts ILIKE '%Salman Khan%'
     AND
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
	 
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) as Actors,
COUNT(*) as Total_Content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY Actors
ORDER BY Total_Content DESC limit 10;

/* Categorize the content based on the presence of the keywords 'Kill' and 'Voilence' in the description
field. label content containing these keywords as 'Bad' and all other
content as 'Good'. Count how many items fall into each category. */

WITH content_table as 
( 
SELECT 
*,
     CASE 
	 WHEN 
	       description ILIKE '%Kill%' OR
		   description ILIKE '%voilence' THEN 'Bad_Content'
		   ELSE 'Good_Content'
     END category 
FROM netflix
) 
SELECT 
    category,
	COUNT(*) as Total_Content
FROM content_table
GROUP BY category;