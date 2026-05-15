# Netflix Movies and TV Shows Data Analysis using SQL

![](assets/logo.png)

## Overview
This project analyzes Netflix movies and TV shows data using SQL to solve real business problems and extract actionable insights that support content strategy and decision-making.

## Business Problem

- Streaming platforms like Netflix must continuously analyze their content library to make better decisions around content acquisition, production, and audience engagement.

#### The key business challenge is:

- How can we use content metadata (genre, release year, country, cast, ratings, and descriptions) to understand content trends, audience preferences, and platform growth opportunities?

#### This project addresses that challenge by analyzing:
- Content distribution (Movies vs TV Shows)
- Viewer targeting through ratings and genres
- Regional content performance (e.g., India vs other countries)
- Actor and director influence on content volume
- Content freshness and growth trends over time
- Risk-sensitive content using keyword-based classification
- Strategic insights for catalog optimization and recommendation decisions
- The goal is to simulate how a real-world data analyst supports data-driven decision-making for a streaming business.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Executive Summary

- Movies dominate Netflix’s catalog, making up the majority of available content.
- Most Netflix content has been released after 2015, indicating rapid platform expansion.
- The United States and India are the leading content-producing countries.
- TV-MA is the most common rating, indicating Netflix’s strong focus on mature audiences.
- Drama and International genres are the most prevalent on the platform.
- Most movies have a runtime between 90 and 120 minutes.

## Business Recommendations

### Based on the insights, the following actions are recommended:

- Invest more in high-performing content formats such as Movies.
- Strengthen content production and acquisition in the U.S. and India markets.
- Prioritize Drama and International genres in future content strategy.
- Continue targeting mature audiences through TV-MA rated content.
- Maintain optimal movie duration (90–120 minutes) aligned with viewer preference.

## Project Structure
```
├── assets/
│   ├── logo.png
├── data/
│   └── Netflix_data.csv
├── SQL file/
│   └── business_queries.sql
├── presentation/
│   └── sales_analysis_slides.pptx
├── README.md
```

## Dataset

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## SQL Skills Demonstrated

- Aggregate Functions  
- Filtering & Conditional Logic  
- Grouping & Sorting  
- Window Functions  
- Common Table Expressions (CTEs)  
- Subqueries  
- Date & Time Handling  
- Data Type Casting  
- String Manipulation  

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(100),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```

## Project Impact

### This project demonstrates the ability to:
- Translate business questions into analytical queries  
- Work with real-world datasets  
- Apply advanced SQL concepts  
- Communicate insights clearly  
- Think from a business decision-making perspective  


This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

### Author
**Ayush Padaniya**  

📧 Email: aayush.padanya@gmail.com

💼 LinkedIn: [https://linkedin.com/in/ayushpadaniya](https://www.linkedin.com/in/ayush-padaniya-26b212318/)

