--Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
 show_id VARCHAR(6),	
 type VARCHAR(10),
 title	VARCHAR(150),
 director VARCHAR(208),
 castS VARCHAR(1000),
 country VARCHAR(150),
 date_added VARCHAR(50),
 release_year INT,
 rating VARCHAR(10),
 duration VARCHAR(15),
 listed_in VARCHAR(100), 
 description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT (*) as total_content FROM netflix;

SELECT DISTINCT type FROM netflix;

SELECT * FROM netflix;

--15 Business Problems

1. Count the number of Movies vs TV Shows

SELECT 
      type,
      COUNT(*) as total_content
FROM netflix 
GROUP BY type;


2. Find the most common rating for movies and TV shows


SELECT
      type,
	  rating
FROM
(
SELECT
      type,
	  rating,
	  COUNT(*),
	  RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1, 2
) as t1
WHERE
     ranking = 1



3. List all the movies released in a specfic year(e.g, 2021)

--filter 2021
--movies

SELECT * FROM netflix
WHERE
     type = 'Movie'
	 AND
	 release_year = 2021

4. Find the top 10 countries with the most content on netflix

SELECT 
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	  COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

5. Indentify the longest movie or TV show duration

SELECT * FROM netflix
WHERE 
     type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration) FROM netflix)

6.Find content added in last 6 years

SELECT
*
FROM netflix
WHERE
     TO_DATE(date_added,'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '6 years'

	 
7.Find all the movies/Tv shows by director 'Rajiv Chilkar'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

8.List all TV shows with more than 4 seasons

SELECT
      *
FROM netflix
WHERE
     type = 'TV Show'
	 AND
     SPLIT_PART(duration, ' ', 1):: numeric > 4


9.Count the number of content item in each genre

SELECT
      UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	  COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

10.Find each year and the average numbers of content released bu India on nnetflix,
return top 5 years with highest average content release

total content 333/972

SELECT
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  COUNT(*) as yearly_content,
	  ROUND(
	  COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India'):: numeric * 100 ,2) as average_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

11.List all the movies are documented

SELECT * FROM netflix
WHERE 
     listed_in ILIKE '%DOCUMENTARIES%'

12.Find all content without a director

SELECT * FROM netflix
WHERE 
     director IS NULL

13.Find how many movies actor 'Salman Khan' appeared in last 9 years

SELECT * FROM netflix
WHERE
     casts ILIKE '%Salman Khan%'
	 AND
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE)- 9

14.Find the top 5 actors who appeared in the highest number of movies produced in india

SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


15.Catogerize the content based on the presence of the keyword 'kill' and 'voilence' in the description field.
Label content containing these keywords as 'Bad' and all other content as 'Good'.
Count how many items fall into each cateogry.

WITH new_table
AS
(
SELECT
*,
      CASE
	  WHEN
	      description ILIKE '%kill%' OR 
		  description ILIKE '%voilence%' THEN 'Bad_content'
		  ELSE 'Good_content'
		END cateogry
	FROM netflix
)
SELECT
cateogry,
COUNT(*) as total_content
FROM new_table
GROUP BY 1


