



-- 🎬 MOVIE DATA DATABASE SCHEMA
-- Compatible with ETL script (etl.py)
-- ===============================================

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS movie_data;
USE movie_data;

-- ===============================================
-- Step 2: Drop old tables if they exist
-- (Ensures clean setup)
-- ===============================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS movie_genres;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
SET FOREIGN_KEY_CHECKS = 1;

-- ===============================================
-- Step 3: Movies Table
-- ===============================================
CREATE TABLE movies (
    movieId INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INT,
    imdb_id VARCHAR(20),
    director VARCHAR(255),
    plot TEXT,
    box_office VARCHAR(50),
    decade INT
);

-- ===============================================
-- Step 4: Movie Genres Table
-- Each movie can have multiple genres.
-- Linked to movies(movieId)
-- ===============================================
CREATE TABLE movie_genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieId INT,
    genre VARCHAR(100),
    FOREIGN KEY (movieId) REFERENCES movies(movieId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ===============================================
-- Step 5: Ratings Table
-- Each user rates a movie.
-- Linked to movies(movieId)
-- ===============================================
CREATE TABLE ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    movieId INT,
    rating FLOAT,
    timestamp BIGINT,
    FOREIGN KEY (movieId) REFERENCES movies(movieId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ===============================================
-- ✅ Step 6: Verification
-- Check all tables exist and constraints applied
-- ===============================================
SHOW TABLES;