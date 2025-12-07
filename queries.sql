-- ============================================
-- Task 5: Analytical SQL Queries
-- ============================================

-- 1️⃣ Which movie has the highest average rating?
SELECT 
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM 
    ratings r
JOIN 
    movies m ON r.movieId = m.movieId
GROUP BY 
    m.title
ORDER BY 
    avg_rating DESC
LIMIT 1;


-- 2️⃣ What are the top 5 movie genres that have the highest average rating?
SELECT 
    mg.genre,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM 
    ratings r
JOIN 
    movie_genres mg ON r.movieId = mg.movieId
GROUP BY 
    mg.genre
ORDER BY 
    avg_rating DESC
LIMIT 5;


-- 3️⃣ Who is the director with the most movies in this dataset?
SELECT 
    director,
    COUNT(*) AS movie_count
FROM 
    movies
WHERE 
    director IS NOT NULL AND director <> 'Unknown'
GROUP BY 
    director
ORDER BY 
    movie_count DESC
LIMIT 1;


-- 4️⃣ What is the average rating of movies released each year?
SELECT 
    m.year,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM 
    ratings r
JOIN 
    movies m ON r.movieId = m.movieId
WHERE 
    m.year IS NOT NULL
GROUP BY 
    m.year
ORDER BY 
    m.year;