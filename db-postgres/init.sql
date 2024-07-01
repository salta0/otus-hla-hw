CREATE TABLE users (
    id              uuid NOT NULL UNIQUE,
    password        varchar(200) NOT NULL,
    access_token    uuid UNIQUE,
    first_name      varchar(50) NOT NULL,
    last_name       varchar(50) NOT NULL,
    birthdate       date,
    biography       text,
    city            varchar(50)
);

COPY users (id, password, access_token, last_name, first_name, birthdate, biography, city)
FROM program 'gunzip -c /tmp/users.csv.gz' DELIMITER ',' CSV HEADER;

CREATE INDEX l_last_name_l_first_name_users_idx ON 
users (lower(last_name) varchar_pattern_ops, lower(first_name) varchar_pattern_ops);

CREATE TABLE users_friends (
    user_id uuid NOT NULL,
    friend_id uuid NOT NULL,
    created_at timestamp DEFAULT NOW()
);

CREATE INDEX user_id_users_friends_idx ON users_friends (user_id);
CREATE INDEX friend_id_users_friends_idx ON users_friends (friend_id);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id uuid NOT NULL,
    created_at timestamp DEFAULT NOW(),
    body text
);
CREATE INDEX user_id_posts_idx ON posts (user_id);
CREATE INDEX created_at_posts_idx ON posts (created_at);

COPY posts (id, user_id, created_at, body)
FROM program 'gunzip -c /tmp/posts.csv.gz' DELIMITER ',' CSV HEADER;
