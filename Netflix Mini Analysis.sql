-- Step 1: Create Tables
CREATE Database NETFLIX;
USE NETFLIX;
-- Users Table
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  gender CHAR(1),
  region VARCHAR(100),
  signup_date DATE
);

-- Shows Table
CREATE TABLE shows (
  show_id INT PRIMARY KEY,
  title VARCHAR(200),
  genre VARCHAR(100),
  release_year INT,
  show_type VARCHAR(50),
  rating VARCHAR(10)
);

-- Watch History Table
CREATE TABLE watch_history (
  watch_id INT PRIMARY KEY,
  user_id INT,
  show_id INT,
  watch_time INT, -- in minutes
  watch_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (show_id) REFERENCES shows(show_id)
);

-- Subscriptions Table
CREATE TABLE subscriptions (
  sub_id INT PRIMARY KEY,
  user_id INT,
  plan_type VARCHAR(50),
  start_date DATE,
  end_date DATE,
  revenue DECIMAL(10,2),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Feedback Table
CREATE TABLE feedback (
  feedback_id INT PRIMARY KEY,
  user_id INT,
  show_id INT,
  rating INT, -- out of 5
  thumbs_up BOOLEAN,
  feedback_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (show_id) REFERENCES shows(show_id)
);

-- Step 2: Insert Dummy Data

-- Users
INSERT INTO users VALUES
(1, 'Rahul', 23, 'M', 'Delhi', '2021-02-10'),
(2, 'Priya', 31, 'F', 'Bangalore', '2022-01-03'),
(3, 'Aman', 27, 'M', 'Mumbai', '2023-05-18'),
(4, 'Neha', 35, 'F', 'Pune', '2022-11-20');

-- Shows
INSERT INTO shows VALUES
(101, 'Stranger Things', 'Thriller', 2016, 'Series', 'PG-13'),
(102, 'The Crown', 'Drama', 2016, 'Series', 'TV-MA'),
(103, 'Money Heist', 'Action', 2017, 'Series', 'TV-MA'),
(104, 'The Social Dilemma', 'Documentary', 2020, 'Movie', 'PG');

-- Watch History
INSERT INTO watch_history VALUES
(1, 1, 101, 120, '2023-08-01'),
(2, 2, 102, 90, '2023-08-03'),
(3, 3, 103, 140, '2023-08-05'),
(4, 1, 104, 100, '2023-08-06');

-- Subscriptions
INSERT INTO subscriptions VALUES
(1, 1, 'Premium', '2023-01-01', '2023-12-31', 1999.00),
(2, 2, 'Basic', '2023-03-01', '2023-09-01', 499.00),
(3, 3, 'Standard', '2023-05-01', '2023-11-01', 999.00);

-- Feedback
INSERT INTO feedback VALUES
(1, 1, 101, 4, TRUE, '2023-08-02'),
(2, 2, 102, 5, TRUE, '2023-08-04'),
(3, 3, 103, 3, FALSE, '2023-08-06'),
(4, 1, 104, 5, TRUE, '2023-08-07');

-- SHOW ALL USERS
SELECT * FROM users;

-- Count Total Number of Shows
SELECT COUNT(*) as Total_Shows FROM shows;

-- List All Unique Genres
SELECT DISTINCT(genre)
FROM shows;

-- Top 5 Shows by IMDB Rating
SELECT f.show_id, s.title, f.rating 
FROM feedback f 
JOIN shows s ON f.show_id=s.show_id
ORDER BY f.rating DESC
LIMIT 5;

-- How Many Users per Region?
SELECT COUNT(user_id), region
FROM users
GROUP BY region;

-- Total Watch Time per User
SELECT w.user_id, u.name, SUM(w.watch_time) as TOTAL
FROM watch_history w
JOIN users u ON u.user_id=w.user_id
GROUP BY user_id;

-- Top 3 Most Watched Shows (by total watch time)
SELECT w.show_id, s.title, SUM(w.watch_time) as 'Total_watch_Time'
FROM watch_history w
JOIN shows s ON w.show_id=s.show_id
GROUP BY w.show_id, s.title
ORDER BY Total_watch_Time DESC;

--  Region-wise Watch Time
SELECT u.region, SUM(w.watch_time)
FROM watch_history w
JOIN users u ON u.user_id = w.user_id
GROUP BY u.region;

-- User Type — Light / Moderate / Heavy Watchers
SELECT u.user_id, u.name, SUM(w.watch_time),
CASE
WHEN SUM(w.watch_time) < 100 THEN 'LIGHT'
WHEN SUM(w.watch_time) BETWEEN 100 AND 300 THEN 'Moderate'
ELSE 'HEAVY'
END AS user_type
FROM users u
JOIN watch_history w ON u.user_id = w.user_id
GROUP BY u.user_id, u.name;

-- Monthly Active Users (MAU)
SELECT 
  DATE_FORMAT(w.watch_date, '%Y-%m') AS month,
  COUNT(DISTINCT w.user_id) AS active_users
FROM watch_history w
GROUP BY month
ORDER BY month;

-- Subscription Revenue per Plan
SELECT SUM(revenue) as Total_revenue, plan_type
FROM subscriptions
GROUP BY plan_type
ORDER BY total_revenue;

-- Type-wise Count
SELECT COUNT(*) as count, show_type
FROM shows
GROUP BY show_type;

-- Release Year Trend
SELECT release_year, COUNT(*)
FROM shows
GROUP BY release_year;

-- Missing Release Year?
SELECT show_id, COALESCE(release_year, "NA") as year
FROM shows
where release_year IS NULL OR release_year='';

-- Distinct Genres (if not comma-separated — we’ll do full genre-split later)
SELECT DISTINCT genre
FROM shows;

-- Top Genres (if genre is clean)
SELECT genre, COUNT(*) AS genre_count
FROM shows
GROUP BY genre
ORDER BY genre_count DESC;

-- Total Count per Genre
SELECT genre, COUNT(*) AS show_count
FROM shows
GROUP BY genre
ORDER BY show_count DESC;

-- Genre-wise Count by Type (Movie vs Series)
SELECT genre, show_type, COUNT(*) AS count
FROM shows
GROUP BY genre, show_type
ORDER BY genre, show_type;

-- Genre-wise Release Trend
SELECT genre, release_year, COUNT(*)
FROM shows
GROUP BY release_year, genre;

-- Top Genres Overall
SELECT genre, COUNT(*) AS total
FROM shows
GROUP BY genre
ORDER BY total DESC
LIMIT 5;

-- Year-wise Show Releases
SELECT release_year, COUNT(*) as Total_shows
FROM shows
GROUP BY release_year;

-- Year + Type-wise Show Releases
SELECT release_year, show_type, COUNT(*) as Total_shows
FROM shows
GROUP BY release_year, show_type;

-- Latest Shows
SELECT show_id, release_year
FROM shows
ORDER BY release_year Desc;

-- Missing or Invalid Release Years?
SELECT show_id, title, COALESCE(release_year, 'NA') AS release_info
FROM shows
WHERE release_year IS NULL OR release_year = '';

-- Top Genres Over Time
SELECT release_year, genre, COUNT(*) AS count
FROM shows
GROUP BY release_year, genre
ORDER BY release_year, count DESC;

-- Average User Rating Per Show
SELECT f.user_id, s.show_id, ROUND(AVG(f.rating),0)
FROM feedback f
JOIN shows s on s.show_id=f.show_id
GROUP BY f.user_id, s.show_id;

-- Thumbs Up Percentage Per Show
SELECT 
  s.title,
  COUNT(*) AS total_feedbacks,
  SUM(f.thumbs_up) AS total_likes,
  ROUND(SUM(f.thumbs_up) * 100.0 / COUNT(*), 2) AS like_percentage
FROM shows s
JOIN feedback f ON s.show_id = f.show_id
GROUP BY s.show_id, s.title
ORDER BY like_percentage DESC;

-- Most Active Users (based on feedback)
SELECT 
  user_id,
  COUNT(thumbs_up) AS total_feedbacks
FROM feedback
GROUP BY user_id
ORDER BY total_feedbacks DESC;

-- Monthly Feedback Trends
SELECT DATE_FORMAT(feedback_date, '%M') as Month, COUNT(thumbs_up)
FROM feedback
GROUP BY Month;

--  Top Rated Genres (User Ratings)
SELECT s.genre, AVG(f.rating)
FROM shows s
JOIN feedback f ON f.show_id = s.show_id
GROUP BY s.genre
ORDER BY AVG(f.rating) desc;

-- Binge Watchers
-- Users who watched more than 200 minutes in a day
SELECT 
  w.user_id,
  u.name,
  w.watch_date,
  SUM(w.watch_time) AS total_watch_time
FROM watch_history w
JOIN users u ON w.user_id = u.user_id
GROUP BY w.user_id, w.watch_date
HAVING SUM(w.watch_time) > 200
ORDER BY total_watch_time DESC;


-- Watch Time vs Feedback Quality
SELECT 
  w.user_id,
  u.name,
  w.avg_watch_time,
  f.avg_rating
FROM
  (SELECT user_id, ROUND(AVG(watch_time), 2) AS avg_watch_time
   FROM watch_history
   GROUP BY user_id) w
JOIN
  (SELECT user_id, ROUND(AVG(rating), 2) AS avg_rating
   FROM feedback
   GROUP BY user_id) f
ON w.user_id = f.user_id
JOIN users u ON u.user_id = w.user_id
ORDER BY w.avg_watch_time DESC;


-- Genre-wise Total Watch Time Analysis
SELECT s.genre, SUM(w.watch_time) as Total_watch_time
FROM shows s
JOIN watch_history w ON w.show_id = s.show_id
GROUP BY s.genre
ORDER BY Total_watch_time desc;

-- Genre Popularity by Region

WITH genre_watch AS (
  SELECT 
    u.region,
    s.genre,
    SUM(w.watch_time) AS total_watch_time
  FROM watch_history w
  JOIN users u ON w.user_id = u.user_id
  JOIN shows s ON w.show_id = s.show_id
  GROUP BY u.region, s.genre
),
ranked_genres AS (
  SELECT *,
         RANK() OVER (PARTITION BY region ORDER BY total_watch_time DESC) AS genre_rank
  FROM genre_watch
)
SELECT region, genre, total_watch_time
FROM ranked_genres
WHERE genre_rank = 1;

-- Genre Popularity Over Time (Top Genre Per Year)

with top_genre as (
SELECT s.genre, s.release_year, SUM(w.watch_time) as total_watch_time
FROM shows s
JOIN watch_history w
ON s.show_id=w.show_id
GROUP BY s.genre, s.release_year)
,
ranked_genres AS (
  SELECT *,
         RANK() OVER (PARTITION BY release_year ORDER BY total_watch_time DESC) AS rnk
  FROM top_genre
)
SELECT * 
FROM ranked_genres
WHERE rnk=1
ORDER BY total_watch_time;

-- Top Watcher per Genre
WITH genre_rn as (
SELECT u.user_id, u.name, s.genre, SUM(w.watch_time) as total_watch
FROM users u
JOIN watch_history w ON u.user_id=w.user_id
JOIN shows s ON s.show_id=w.show_id
GROUP BY u.user_id, u.name, s.genre),

top_watcher as (
SELECT *, RANK() OVER
( Partition BY genre 
ORDER BY total_watch DESC) as rnk
FROM genre_rn
)

SELECT name, genre, total_watch
FROM top_watcher
where rnk=1
ORDER BY total_watch;

-- Plan-Wise Revenue + Watch Time Summary
-- total time
-- total watch time
-- partition by plan

SELECT u.name, sub.plan_type, SUM(w.watch_time) as total_watch, SUM(sub.revenue) as total_revenue
FROM subscriptions sub
JOIN watch_history w ON w.user_id=sub.user_id
JOIN users U ON u.user_id=w.user_id
GROUP BY plan_type, name;

WITH plan_watch AS (
  SELECT 
    u.user_id,
    s.plan_type,
    SUM(w.watch_time) AS total_watch_time
  FROM users u
  JOIN subscriptions s ON u.user_id = s.user_id
  LEFT JOIN watch_history w ON u.user_id = w.user_id
  GROUP BY u.user_id, s.plan_type
),
summary AS (
  SELECT 
    plan_type,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(total_watch_time) AS total_watch_time
  FROM plan_watch
  GROUP BY plan_type
)
SELECT 
  s.plan_type,
  COUNT(DISTINCT s.user_id) AS total_users,
  SUM(s.revenue) AS total_revenue,
  COALESCE(sw.total_watch_time, 0) AS total_watch_time
FROM subscriptions s
LEFT JOIN summary sw ON s.plan_type = sw.plan_type
GROUP BY s.plan_type, sw.total_watch_time
ORDER BY total_revenue DESC;

-- Churn Detection
-- users whose subscription has ended but they have not watched anything after that.
SELECT 
  u.user_id,
  u.name,
  s.end_date,
  MAX(w.watch_date) AS last_watch_date,
  CASE
    WHEN MAX(w.watch_date) IS NULL OR MAX(w.watch_date) <= s.end_date THEN 'Churned'
    ELSE 'Active'
  END AS churn_status
FROM users u
JOIN subscriptions s ON u.user_id = s.user_id
LEFT JOIN watch_history w ON u.user_id = w.user_id
GROUP BY u.user_id, u.name, s.end_date;


-- Retention Rate (Plan-wise)
WITH user_last_watch AS (
  SELECT user_id, MAX(watch_date) AS last_watch_date
  FROM watch_history
  GROUP BY user_id
),
churn_flag AS (
  SELECT 
    s.user_id,
    s.plan_type,
    s.end_date,
    uw.last_watch_date,
    CASE 
      WHEN uw.last_watch_date > s.end_date THEN 1
      ELSE 0
    END AS retained
  FROM subscriptions s
  LEFT JOIN user_last_watch uw ON s.user_id = uw.user_id
)
SELECT 
  plan_type,
  COUNT(*) AS total_users,
  SUM(retained) AS retained_users,
  ROUND(SUM(retained) * 100.0 / COUNT(*), 2) AS retention_rate
FROM churn_flag
GROUP BY plan_type;

