CREATE DATABASE IF NOT EXISTS Quackstagram;
USE Quackstagram;

CREATE TABLE User (
    username VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    bio TEXT
);

CREATE TABLE Post (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    image_path VARCHAR(255) NOT NULL,
    caption TEXT,
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE
);

CREATE TABLE Comment (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    username VARCHAR(255),
    content TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE
);

CREATE TABLE `Like` (
    post_id INT,
    username VARCHAR(255),
    PRIMARY KEY (post_id, username),
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE
);

CREATE TABLE Follow (
    follower_username VARCHAR(255),
    followed_username VARCHAR(255),
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_username) REFERENCES User(username) ON DELETE CASCADE,
    FOREIGN KEY (followed_username) REFERENCES User(username) ON DELETE CASCADE
);

CREATE TABLE Notification (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    post_id INT,
    notified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE
);


/* Populating the database */

--INSERT INTO statements + dummy data--
INSERT INTO User(username, password, bio)
VALUES ('checkpointmember', 'passing123', 'Testing the account for checkpoint');

-- dummy data done generated using Gemini (LLM) --

-- Add dummy users for testing 
INSERT INTO User (username, password, bio) VALUES 
('ducky_coder', 'quack789', 'I love databases!'),
('maastricht_student', 'um_2024', 'Studying in the library.');

-- Add dummy posts
INSERT INTO Post (username, image_path, caption) VALUES 
('ducky_coder', 'uploads/p1.png', 'My first database post!'),
('maastricht_student', 'uploads/p2.png', 'Look at this cool query result');

-- Add dummy comments
INSERT INTO Comment (post_id, username, content) VALUES 
(1, 'maastricht_student', 'Great work on the schema!'),
(2, 'ducky_coder', 'Very efficient design.');

-- Add dummy follows and likes
INSERT INTO Follow (follower_username, followed_username, followed_at) VALUES 
('ducky_coder', 'maastricht_student', 2024-01-15 10:30:00);

INSERT INTO `Like` (post_id, username) VALUES 
(1, 'maastricht_student'),
(2, 'ducky_coder');

--Add dummy notification
INSERT INTO Notification (post_id, username) VALUES 
(1, 'maastricht_student'),
(2, 'ducky_coder');


