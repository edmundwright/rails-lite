CREATE DATABASE rails_lite_app;

\connect rails_lite_app;

CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  breed varchar(255) NOT NULL
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  session_token VARCHAR(255),
  password_digest VARCHAR(255)
);
