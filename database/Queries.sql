-- 1. List all users who have more than X followers where X can be any integer
-- value.
SELECT followed_username, COUNT(*) AS followers
FROM Follow
GROUP BY followed_username
HAVING COUNT(*) > 10;  -- X = 10

-- 2. Show the total number of posts made by each user. (You will have to
-- decide how this is done, via a username or userid)
SELECT username, COUNT(*) AS total_posts
FROM Post
GROUP BY username;

-- 3. Find all comments made on a particular user’s post.
SELECT c.*
FROM Comment c
JOIN Post p ON c.post_id = p.post_id
WHERE p.username = 'henry_games';  -- patricular user = henry_games

-- 4. Display the top X most liked posts.
SELECT post_id, COUNT(*) AS total_likes
FROM `Like`
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5; -- X = 5

-- 5. Count the number of posts each user has liked.
SELECT username, COUNT(*) AS posts_liked
FROM `Like`
GROUP BY username;

-- 6. List all users who haven’t made a post yet.
SELECT username
FROM User
WHERE username NOT IN (SELECT username FROM Post);

-- 7. List users who follow each other.
SELECT x.follower_username, x.followed_username
FROM Follow x
JOIN Follow y ON x.follower_username = y.followed_username AND x.followed_username = y.follower_username;

-- 8. Show the user with the highest number of posts.
SELECT username, COUNT(*) AS total_posts
FROM Post
GROUP BY username
ORDER BY total_posts DESC
LIMIT 1;

-- 9. List the top X users with the most followers.
SELECT followed_username, COUNT(*) AS followers
FROM Follow
GROUP BY followed_username
ORDER BY followers DESC
LIMIT 5; -- X = 5

-- 10. Find posts that have been liked by all users.
SELECT post_id
FROM `Like`
GROUP BY post_id
HAVING COUNT(DISTINCT username) = (SELECT COUNT(*) FROM User);

-- 11. Display the most active user (based on posts, comments 7, and likes).
SELECT username, (posts + comments + likes) AS activity_score
FROM (
    SELECT u.username, COUNT (DISTINCT p.post_id) AS posts, COUNT (DISTINCT c.comment_id) AS comments, COUNT (DISTINCT l.post_id) AS likes
    FROM User u
    LEFT JOIN Post p ON u.username = p.username
    LEFT JOIN Comment c ON u.username = c.username
    LEFT JOIN `Like` l ON u.username = l.username
    GROUP BY u.username
) AS activity
ORDER BY activity_score DESC
Limit 1;

-- 12. Find the average number of likes per post for each user.
SELECT p.username, AVG(like_counts.total) AS average_likes
FROM Post p
JOIN (
    SELECT post_id, COUNT(*) AS total
    FROM `Like`
    GROUP BY post_id
) AS like_counts ON p.post_id = like_counts.post_id
GROUP BY p.username;

-- 13. Show posts that have more comments than likes.
SELECT p.post_id, p.username, COUNT(DISTINCT c.comment_id) AS comments, COUNT(DISTINCT l.username) AS likes
FROM Post p
LEFT JOIN Comment c ON p.post_id = c.post_id
LEFT JOIN `Like` l ON p.post_id = l.post_id
GROUP BY p.post_id, p.username
HAVING comments > likes;

-- 14. List the users who have liked every post of a specific user.
SELECT l.username
FROM `Like` l
JOIN Post p ON l.post_id = p.post_id
WHERE p.username = 'henry_gamers' -- paticular user = henry_gamers
GROUP BY l.username
HAVING COUNT(DISTINCT l.post_id) = (SELECT COUNT(*) FROM Post WHERE username = 'henry_gamers');

-- 15. Display the most popular post of each user (based on likes).
-- 16. Find the user(s) with the highest ratio of followers to following.
-- 17. Show the month with the highest number of posts made.
-- 18. Identify users who have not interacted with a specific user’s posts.
-- 19. Display the user with the greatest increase in followers in the last X days.
-- 20. Find users who are followed by more than X.