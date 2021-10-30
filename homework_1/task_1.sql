-- используем базу данных example
USE example;

-- удаляем, если существует таблицу user
DROP TABLE IF EXISTS users;
-- создаем таблицу user
CREATE TABLE users (
-- первое поле
id SERIAL PRIMARY KEY,
-- второе поле
name VARCHAR(255)
);

-- выводим поля таблицы
SElECT id, name FROM users;