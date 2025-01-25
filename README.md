# Netflix Movies and TV Shows Data Analysis using SQL
![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    [type],
    COUNT(*) AS Total_Content_By_Type
FROM netflix_titles$
GROUP BY [type];
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix_titles$
WHERE [type] = 'Movie' AND release_year = 2020
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
    (),
    COUNT(*)
FROM netflix_titles$
GROUP BY country
ORDER BY COUNT(*) DESC
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT 
    top 5
    *
FROM netflix_titles$
WHERE [type] = 'Movie' AND duration = (select MAX(duration) from netflix_titles$)
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select 
    * 
FROM netflix_titles$
WHERE DATEPART(YEAR, date_added) >= DATEPART(YEAR, GETDATE()) - 5
ORDER BY date_added DESC
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT 
    [type],
    count(*) as total_content_by_director
FROM netflix_titles$
WHERE director LIKE '%Rajiv Chilaka%'
GROUP BY [type]
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix_titles$
WHERE [type] = 'tv show' AND CAST(SUBSTRING(duration, 1, CHARINDEX(' ',duration) -1) as int) > 5
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    genre,
    COUNT(*) as total_content_by_genre 
FROM(
    select value as genre 
    FROM netflix_titles$
    CROSS APPLY string_split(listed_in, ',')
) as genre
GROUP BY genre
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT 
    DATEPART(YEAR, date_added) as year,
    count(*) as total_content,
    (cast(count(*) as int) * 100 / cast((select count(*) from netflix_titles$ where country = 'India') as int)) as avg_content
FROM netflix_titles$
WHERE country = 'India' and DATEPART(YEAR, date_added) is not null
GROUP BY DATEPART(YEAR, date_added)
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
    * 
FROM netflix_titles$
WHERE [type] = 'Movie' AND listed_in LIKE '%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM netflix_titles$
WHERE director IS NULL
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT 
    [type],
    COUNT(*) as total_content_by_salman
FROM netflix_titles$
WHERE [cast] LIKE '%Salman Khan%' AND release_year >= DATEPART(YEAR, GETDATE()) - 10
GROUP by [type]
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.


