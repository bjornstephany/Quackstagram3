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
    PRIMARY KEY (follower_username, followed_username),
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
