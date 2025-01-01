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