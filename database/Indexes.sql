-- Design at least 2 indexes to optimize the performance of these views and overall query speed. 
-- You need to document the performance of queries before and after the index application
-- to demonstrate the improvement and justify the application

-- Indexes are good for columns you select a lot but don't update a lot on non primary keys

CREATE INDEX idx_post_username ON Post(username);

CREATE INDEX idx_comment_username ON Comment(username);

CREATE INDEX idx_like_username ON `Like`(username);

CREATE INDEX idx_like_post_id ON `Like`(post_id);