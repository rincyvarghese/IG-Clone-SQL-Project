
-- 1. We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users
order by created_at
limit 5;

-- 2. To understand when to run the ad campaign, figure out the day of the week most users register on? 

select dayname(created_at) name_of_day, count(*) user_num 
from users
group by name_of_day
order by user_num desc
limit 2;

-- 3. To target inactive users in an email ad campaign, find the users who have never posted a photo.

-- using left join

select u.id, u.username, p.id 
from users u
left join photos p on u.id=p.user_id
where p.id is null
order by u.id;

-- using subqueries

select u.id, u.username 
from users u 
where u.id not in(select p.user_id from photos p)
order by u.id;


-- 4. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?


select u.id, u.username, l.photo_id, count(*) total_likes
from likes l
inner join photos p on p.id = l.photo_id
inner join users u on u.id = p.user_id 
group by l.photo_id
order by total_likes desc
limit 1;


-- 5. The investors want to know how many times does the average user post.

-- average post count(in whole scheme)

select((select count(*) from photos)/(select count(*) from users)) avg_post_count;


-- 6. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

select t.tag_name, count(*) tag_count 
from photo_tags pt
inner join tags t on t.id = pt.tag_id
group by tag_name
order by tag_count desc
limit 5;


-- 7. To find out if there are bots, find users who have liked every single photo on the site.

select u.id, u.username, count(*) user_like_count 
from likes l 
inner join users u on l.user_id = u.id
group by l.user_id
having count(*) = (select count(*) from photos);


-- 8. To know who the celebrities are, find users who have never commented on a photo.

-- using left join

select u.id, u.username, c.comment_text from 
users u 
left join comments c on 
c.user_id = u.id
where c.user_id is null
order by u.id;

-- using subqueries

select id, username 
from users 
where id not in(select user_id from comments)
order by id;

-- 9. Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.

with cte1 as
(
select u.id, u.username, c.comment_text from 
users u 
left join comments c on 
c.user_id = u.id
where c.user_id is null),
cte2 as
(select user_id, u.username, c.comment_text, count(*) from comments c
inner join users u on u.id = c.user_id
group by user_id
having count(*)=(select count(*) from photos))

select cte1.id,cte1.username,cte1.comment_text from cte1
union all 
select cte2.user_id, cte2.username,cte2.comment_text from cte2 ;
