-- ----------------------------
-- Data Analysis -Easy Category
-- ----------------------------
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify 
where stream >= 1000000000 ;

-- 2. List all albums along with their respective artists.
select distinct album,artist from spotify
order by album ;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
select  count(comments) total_comments
from spotify
where licensed = 'TRUE';

-- 4. Find all tracks that belong to the album type single.
select * from spotify
where album_type = 'single';

-- 5. Count the total number of tracks by each artist.
select artist,count(track) as total_songs
from spotify 
group by  artist 
order by total_songs desc ;

-- --------------------------------
-- Data Analysis - Medium  Category
-- --------------------------------
select * from spotify ;
-- 1. Calculate the average danceability of tracks in each album.
select album,avg(danceability) from spotify
where album_type = 'album'
group by album 
;
-- 2. Find the top 5 tracks with the highest energy values.
select * from spotify
order by energy desc 
limit 5 ;
-- 3. List all tracks along with their views and likes where official_video = TRUE.
select 
	artist,
	track,
	album,
	album_type,
	track,
	views,likes,comments
from spotify
where official_video = 'True' ;
	
-- 4. For each album, calculate the total views of all associated tracks.
select album,sum(views) as Total_Views
from spotify 
group by album 
order by Total_Views desc ;
-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.
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
---------------------------
-- Data Analysis - Advanced  Category
-- ----------------------------------
-- 1. Find the top 3 most-viewed tracks for each artist using window functions.
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
-- 2. Write a query to find tracks where the liveness score is above the average.
select * from spotify
where liveness > (select avg(liveness) from spotify) ;

-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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
-- 4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
select 
	track,
	energy_liveness
from spotify 
where energy_liveness > 1.2 ;
-- 5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
select 
	track,
	sum(likes) over(order by views) as total_Likes
from spotify  
order by total_likes desc ; 