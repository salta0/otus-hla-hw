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
