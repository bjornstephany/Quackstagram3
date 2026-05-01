-- Design at least 2 indexes to optimize the performance of these views and overall query speed. 
-- You need to document the performance of queries before and after the index application
-- to demonstrate the improvement and justify the application

-- Indexes are good for columns you select a lot but don't update a lot on non primary keys

CREATE INDEX post_username ON Post (username);
CREATE INDEX like_postID ON `Like` (post_id);

-- PRE INDEX VIEW SPEEDS:
-- SHOW_MOST_ACTIVE_USER = 
-- LIST_USERS_WITHOUT_POSTS = 
-- SHOW_POPULAR_POSTS = 

-- POST INDEX VIEW SPEEDS:
-- SHOW_MOST_ACTIVE_USER = 
-- LIST_USERS_WITHOUT_POSTS = 
-- SHOW_POPULAR_POSTS = 