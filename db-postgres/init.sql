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

CREATE INDEX l_last_name_l_first_name_users_idx ON 
users (lower(last_name) varchar_pattern_ops, lower(first_name) varchar_pattern_ops);
