# Spotify-Data-Analysis-SQL


## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.
  

```sql 
-- EDA
select * from spotify ;

-- Unique Artists
select count(distinct artist) from spotify  ;

-- Unique Albums 
select count(distinct album) from spotify ;

-- Unique Albums Types
select distinct album_type from spotify ;

-- Max Duration
select max(duration_min) 
from spotify ;

select * from spotify
where duration_min = 0 ;
-- Delete the songs
delete from spotify 
where duration_min = 0 ;

select count(distinct channel) from spotify ;

select distinct most_played_on from spotify ;

-- What is Most Streamed Song
select * from spotify 
where stream = (select max(stream) from spotify) ;

-- What is Most Likes Song
select * from spotify 
where likes = (select max(likes) from spotify) ;

-- Top 3 Liked Songs
WITH ranked_songs AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY likes ORDER BY likes DESC) AS rank
  FROM spotify
)
SELECT *
FROM ranked_songs
limit 3 ;
```
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
select * from spotify 
where stream >= 1000000000 ;
```
2. List all albums along with their respective artists.
```sql
select distinct album,artist from spotify
order by album ;
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
select  count(comments) total_comments
from spotify
where licensed = 'TRUE';
```
4. Find all tracks that belong to the album type `single`.
```sql
select * from spotify
where album_type = 'single';
```
5. Count the total number of tracks by each artist.
```sql
select artist,count(track) as total_songs
from spotify 
group by  artist 
order by total_songs desc ;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
select album,avg(danceability) from spotify
where album_type = 'album'
group by album 
;
```
2. Find the top 5 tracks with the highest energy values.
```sql
select * from spotify
order by energy desc 
limit 5 ;
```
3. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
select 
	artist,
	track,
	album,
	album_type,
	track,
	views,likes,comments
from spotify
where official_video = 'True' ;
```
4. For each album, calculate the total views of all associated tracks.
```sql
select album,sum(views) as Total_Views
from spotify 
group by album 
order by Total_Views desc ;
```
5. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
select * from 
(
select
	track,
	coalesce (sum((case when most_played_on = 'Youtube' then stream end)),0) as stream_on_youtube,
	coalesce (sum((case when most_played_on = 'Spotify' then stream end)),0) as stream_on_spotify
from spotify 
group by track 
) as t1
where stream_on_spotify > stream_on_youtube
and stream_on_youtube != 0
;
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
with most_viewed as
( select 
	artist,
	track,
	sum(views) as total_views,
	dense_rank() over(partition by artist order by sum(views) desc) as Ranking
from spotify 
group by artist,track
order by artist,total_views desc 
)
select * from most_viewed where ranking <= 3
;
```
2. Write a query to find tracks where the liveness score is above the average.
```sql
select * from spotify
where liveness > (select avg(liveness) from spotify) ;
```
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
with cte as
(select 
	album,
	max(energy) as Highest_Energy,
	min(energy) as Lowest_Energy
from spotify 
group by album 
)
select 
	album,
	Highest_Energy - Lowest_Energy as Difference
from cte 
order by Difference desc
;	
```
   
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
select 
	track,
	energy_liveness
from spotify 
where energy_liveness > 1.2 ;
```
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
select 
	track,
	sum(likes) over(order by views) as total_Likes
from spotify  
order by total_likes desc ; 
```
