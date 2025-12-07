
CREATE DATABASE IF NOT EXISTS movie_data;
USE movie_data;


SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS movie_genres;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
SET FOREIGN_KEY_CHECKS = 1;


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


CREATE TABLE movie_genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieId INT,
    genre VARCHAR(100),
    FOREIGN KEY (movieId) REFERENCES movies(movieId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


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


SHOW TABLES;
