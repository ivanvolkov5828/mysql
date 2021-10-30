-- удаляем базу данных, если она существует
DROP DATABASE IF EXISTS sample;
-- создаем базу данных sample
CREATE DATABASE sample;
-- создаем дамп базы данных example
mysqldump example > example.sql
--  открываем дамп в б.д sample
mysql sample < example.sql

