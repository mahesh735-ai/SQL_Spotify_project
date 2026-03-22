--SQL Spotify Project--

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--Import the Dataset
SELECT * FROM Spotify;

--EDA
SELECT COUNT(*) FROM spotify       -- 2 rows we had deleted ok

SELECT COUNT(DISTINCT Artist ) FROM spotify

SELECT COUNT(DISTINCT album ) FROM spotify

SELECT DISTINCT album_type FROM spotify

SELECT MAX(duration_min) FROM spotify

SELECT MIN(duration_min) FROM spotify

--Here We find The data is Incosistent
--so we now delete Those Row where have 0 Value

SELECT * FROM spotify
WHERE duration_min = 0; --2 songs find --- This 2 rows we deleted

DELETE FROM spotify
WHERE duration_min = 0;

--now Check
SELECT * FROM spotify
WHERE duration_min = 0; --no song left (it deleted)

SELECT DISTINCT channel FROM Spotify;

SELECT DISTINCT most_played_on FROM spotify;

-"Solve The Business Problem"--

-- ----------------------------------
-- Data Analysis - Easy Level
-- ----------------------------------

/*
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.
*/

--1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify 
WHERE stream > 1000000000;

--2. List all albums along with their respective artists.

SELECT 
	DISTINCT album,artist 
FROM spotify
ORDER BY 1;

--3. Get the total number of comments for tracks where `licensed = TRUE`.
SELECT Distinct licensed FROM spotify       ---use small later ok for true and false

select * from spotify
where licensed = 'true';

select SUM(comments) as total_comments
from spotify
where licensed = 'true';

--4. Find all tracks that belong to the album type `single`.
SELECT * FROM spotify 

SELECT * FROM spotify 
WHERE album_type =  'single'; 

--5. Count the total number of tracks by each artist.

select 
	artist ,
	Count(track) as Total_no_Tracks
FROM spotify
GROUP BY artist
ORDER BY Total_no_Tracks DESC;

-- ----------------------------------
-- Data Analysis - Medium Level
-- ----------------------------------
/*
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where `official_video = TRUE`.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.*/

SELECT * FROM Spotify ;

--1. Calculate the average danceability of tracks in each album.

SELECT album,AVG(danceability) 
FROM Spotify
GROUP BY 1;

SELECT album,AVG(danceability) 
FROM Spotify
GROUP BY 1
order by 2 Desc;

--2. Find the top 5 tracks with the highest energy values.

SELECT * FROM spotify

SELECT track,max(energy) AS Highest_energy
from spotify 
GROUP BY 1
ORDER BY Highest_energy DESC
LIMIT 5;

--3. List all tracks along with their views and likes where `official_video = TRUE`.

SELECT track,
	views,
	likes
FROM Spotify
WHERE official_video = 'TRUE';

--4. For each album, calculate the total views of all associated tracks.

SELECT album,
		track,
		SUM(Views)
FROM spotify
GROUP BY 1,2

--FOR HIGHEST VIEW 

SELECT album,
		track,
		SUM(Views)
FROM spotify
GROUP BY 1,2
ORDER BY 3;

--5. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT 
	Track,
	COALESCE(SUM( CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM( CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_Spotify
From spotify
GROUP BY 1


--final op
select * from 
(SELECT 
	Track,
	COALESCE(SUM( CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM( CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_Spotify
From spotify
GROUP BY 1
) as t2
WHERE  streamed_on_Spotify > streamed_on_Youtube
	AND  streamed_on_youtube <> 0;
	
-- ----------------------------------
-- Data Analysis - Advanced Level
-- ----------------------------------

/* Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
2. Write a query to find tracks where the liveness score is above the average.
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/

--1. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT * FROM spotify

select 
	track,
	artist,
	views,
	RANK( ) OVER(PARTITION BY Artist ORDER BY views DESC ) AS most_viewed_tracks
FROM spotify
LIMIT 3;

--final op
WITH ranking_artist 
AS
(SELECT  Artist,track,
	sum(views) as total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)

SELECT * FROM ranking_artist
WHERE rank <=3;


--2. Write a query to find tracks where the liveness score is above the average.
SELECT * FROM spotify

SELECT
	track,
	Artist,
	liveness
FROM Spotify
where liveness > (SELECT AVG(liveness)from spotify ) 

--3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**

SELECT max(energy) from spotify

WITH Levels
as
(
SELECT album,
	MAX(energy) as Highest_energy,
	MIN(Energy) as Lowest_energy
FROM Spotify
group by 1
)

SELECT album,
		highest_energy - lowest_energy as energy_diff
from levels
order by 2 DESC;

--.4 Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT
    track,
    energy,
    liveness,
    (energy::float / NULLIF(liveness, 0)) AS energy_to_liveness_ratio
FROM
    Spotify
WHERE
    (energy::float / NULLIF(liveness, 0)) > 1.2;
--6. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_likes
FROM
   spotify
ORDER BY
    views desc;

                                      -- END PROJECT--


--Extra part--

--QUERY OPTIMIZATION--
--FOR performance

EXPLAIN ANALYZE --Without indexing : The Time of Query "Planning Time: 0.076 ms" and "Execution Time: 4.160 ms"
select artist,
	track,
	views
FROM spotify
where artist ='Gorilla'
 AND
 most_played_on = 'youtube'
order by Stream  DESC
LIMIT 25

CREATE INDEX index_artist ON spotify(artist); 

--With Indexing : now above query time is reduce by "Planning Time: 0.096 ms" and "Execution Time: 0.101 ms" 
--to know about performance of Query check Screen shot .


--over index is also not good option cuz if you do over indexing the DML function is going to take lot of time