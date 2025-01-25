-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

SELECT 
    [type],
    COUNT(*) AS Total_Content_By_Type
FROM netflix_titles$
GROUP BY [type]

-- 2. Find the most common rating for movies and TV shows

SELECT
    [type],
    rating
FROM
(
SELECT 
    [type],
    rating,
    COUNT(*) as rating_count,
    RANK() OVER(partition by type ORDER BY count(*) desc) as ranking
FROM netflix_titles$
group BY [type],rating
) as t1

WHERE ranking = 1


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix_titles$
WHERE [type] = 'Movie' AND release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix

SELECT TOP 5
    country,
    COUNT(*)
FROM netflix_titles$
WHERE country IS NOT NULL
GROUP BY country
ORDER BY COUNT(*) DESC


-- 5. Identify the longest movie

SELECT 
    top 5
    *
FROM netflix_titles$
WHERE [type] = 'Movie' AND duration = (select MAX(duration) from netflix_titles$)



-- 6. Find content added in the last 5 years

select 
    * 
FROM netflix_titles$
WHERE DATEPART(YEAR, date_added) >= DATEPART(YEAR, GETDATE()) - 5
ORDER BY date_added DESC


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
    [type],
    count(*) as total_content_by_director
FROM netflix_titles$
WHERE director LIKE '%Rajiv Chilaka%'
GROUP BY [type]

-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix_titles$
WHERE [type] = 'tv show' AND CAST(SUBSTRING(duration, 1, CHARINDEX(' ',duration) -1) as int) > 5


-- 9. Count the number of content items in each genre


SELECT 
    genre,
    COUNT(*) as total_content_by_genre 
FROM(
    select value as genre 
    FROM netflix_titles$
    CROSS APPLY string_split(listed_in, ',')
) as genre
GROUP BY genre




-- 10.Find each year and the average numbers of content release in India on netflix. 

SELECT 
    DATEPART(YEAR, date_added) as year,
    count(*) as total_content,
    (cast(count(*) as int) * 100 / cast((select count(*) from netflix_titles$ where country = 'India') as int)) as avg_content
FROM netflix_titles$
WHERE country = 'India' and DATEPART(YEAR, date_added) is not null
GROUP BY DATEPART(YEAR, date_added)

-- return top 5 year with highest avg content release!

SELECT top 5
    release_year,
    [type],
    COUNT(*) as total_content,
    count(*) * 100 / (select count(*) from netflix_titles$) as avg_content
FROM netflix_titles$
GROUP BY release_year, [type]
ORDER BY total_content DESC


-- 11. List all movies that are documentaries

SELECT 
    * 
FROM netflix_titles$
WHERE [type] = 'Movie' AND listed_in LIKE '%Documentaries%'


-- 12. Find all content without a director

SELECT *
FROM netflix_titles$
WHERE director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT 
    [type],
    COUNT(*) as total_content_by_salman
FROM netflix_titles$
WHERE [cast] LIKE '%Salman Khan%' AND release_year >= DATEPART(YEAR, GETDATE()) - 10
GROUP by [type]


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT top 10    
    actor,
    COUNT(*)
FROM (
    SELECT 
    [value] AS actor
    FROM netflix_titles$
    CROSS APPLY string_split([cast], ',') as actor
    WHERE country = 'India' AND [type] = 'Movie'
) AS actor
GROUP BY actor
ORDER by count(*) DESC


-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

SELECT 
    category,
    count(*) as total
FROM (
    select 
        case when description like '%kill%' or [description] like '%violence%' then 'Bad'
        else 'Good'
        END category
    from netflix_titles$) as t3
GROUP BY category






























































