DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users
(
user_id SERIAL PRIMARY KEY,
name varchar(50) NOT NULL,
email varchar(50) UNIQUE NOT NULL,
phone_number VARCHAR(20) UNIQUE
);
DROP TABLE IF EXISTS posts CASCADE;
CREATE TABLE posts
(
post_id SERIAL PRIMARY KEY,
user_id INTEGER NOT NULL,
caption TEXT,
image_url VARCHAR(200),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(user_id)
);
DROP TABLE IF EXISTS comments CASCADE;
CREATE TABLE comments
(
comment_id SERIAL PRIMARY KEY,
post_id INTEGER NOT NULL,
user_id INTEGER NOT NULL,
comment_text TEXT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (post_id) REFERENCES posts(post_id),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);
DROP TABLE IF EXISTS likes CASCADE;
CREATE TABLE likes
(
like_id SERIAL PRIMARY KEY,
post_id INTEGER NOT NULL,
user_id INTEGER NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (post_id) REFERENCES posts(post_id),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);
DROP TABLE IF EXISTS followers CASCADE;
CREATE TABLE followers
(
follower_id SERIAL PRIMARY KEY,
user_id INTEGER NOT NULL,
follower_user_id INTEGER NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(user_id),
FOREIGN KEY (follower_user_id) REFERENCES users(user_id)
);
-- Inserting into Users table
INSERT INTO users (name, email, phone_number)
VALUES
('John Smith', 'johnsmith@gmail.com', '1234567890'),
('Jane Doe', 'janedoe@yahoo.com', '0987654321'),
('Bob Johnson', 'bjohnson@gmail.com', '1112223333'),
('Alice Brown', 'abrown@yahoo.com', NULL),
('Mike Davis', 'mdavis@gmail.com', '5556667777');

-- Inserting into Posts table
INSERT INTO posts (user_id, caption, image_url)
VALUES
(1, 'Beautiful sunset', '<https://www.example.com/sunset.jpg>'),
(2, 'My new puppy', '<https://www.example.com/puppy.jpg>'),
(3, 'Delicious pizza', '<https://www.example.com/pizza.jpg>'),
(4, 'Throwback to my vacation', '<https://www.example.com/vacation.jpg>'),
(5, 'Amazing concert', '<https://www.example.com/concert.jpg>');

-- Inserting into Comments table
INSERT INTO comments (post_id, user_id, comment_text)
VALUES
(1, 2, 'Wow! Stunning.'),
(1, 3, 'Beautiful colors.'),
(2, 1, 'What a cutie!'),
(1,4, 'Aww'),
(3,5, 'looks awesome'),
(4,1, 'yum!'),
(5,3, 'yayyy');

INSERT INTO likes(post_id,user_id)
VALUES
(1,2),
(1,4),
(2,1),
(2,3),
(3,5),
(4,1),
(4,2),
(4,3),
(5,4),
(5,5);
INSERT INTO followers(user_id,follower_user_id)
VALUES
(1,2),
(2,1),
(1,3),
(3,1),
(1,4),
(4,1),
(1,5),
(5,1);
select * from users;
select * from posts
ORDER BY created_at DESC;

select * from posts as p
JOIN likes as l ON p.post_id=l.post_id;
-- Finding all the users who have commented on post_id 1
SELECT name FROM users WHERE user_id IN (
    SELECT user_id FROM comments WHERE post_id = 1
);

-- Ranking the posts based on the number of likes
WITH cte AS(
SELECT p.post_id, count(l.like_id) number_likes 
FROM posts as p
JOIN likes as l ON p.post_id = l.post_id
GROUP BY p.post_id
)

SELECT
    post_id,
    number_likes,
    DENSE_RANK() OVER(ORDER BY number_likes DESC) AS rank_by_likes
FROM cte;

-- Finding all the posts and their comments
-- using a Common Table Expression (CTE)
WITH cte AS (
    SELECT p.post_id, p.caption, c.comment_text
    FROM posts p
    LEFT JOIN comments c ON p.post_id = c.post_id
)
SELECT * FROM cte;
-- Categorizing the posts based on the number of likes
WITH cte AS (
    SELECT 
        p.post_id,
        COUNT(l.like_id) AS number_likes
    FROM posts p
    LEFT JOIN likes l ON p.post_id = l.post_id
    GROUP BY p.post_id
)
SELECT
    post_id,
    number_likes,
    CASE
        WHEN number_likes = 0 THEN 'no likes'
        WHEN number_likes = 1 THEN 'low likes'
        WHEN number_likes = 2 THEN 'few likes'
        WHEN number_likes > 2 THEN 'lot of likes'
        ELSE 'no data'
    END AS like_category
FROM cte;

