$create_script = <<-SQL
  CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    body VARCHAR(255) NOT NULL,
    author_id INTEGER NOT NULL
  );

  CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    session_token VARCHAR(255),
    password_digest VARCHAR(255)
  );
SQL
