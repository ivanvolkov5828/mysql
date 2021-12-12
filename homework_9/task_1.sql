-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs
-- помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;

-- создаем таблицу с типом archive
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	str_id BIGINT(20) NOT NULL,
	name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;

-- триггер для таблицы users
DROP TRIGGER IF EXISTS watchlog_users;
delimiter //
CREATE TRIGGER watchlog_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

-- триггер для таблицы catalogs
DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

-- триггер для таблицы products
DROP TRIGGER IF EXISTS watchlog_products;
delimiter //
CREATE TRIGGER watchlog_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;

-- 2. Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- таблица для задания
DROP TABLE IF EXISTS users_for_task;
CREATE TABLE users_for_task (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
);

-- создадим процедуру, чтобы поместить миллион пользователей в таблицу
DROP PROCEDURE IF EXISTS million_users ;
delimiter //
CREATE PROCEDURE million_users()
BEGIN
	DECLARE i INT DEFAULT 1000;
	DECLARE j INT DEFAULT 1;
	WHILE i > 0 DO
		INSERT INTO users_for_task (name) VALUES (CONCAT('user ', j));
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;
END //
delimiter ;

-- вызов процедуры
CALL million_users();

-- смотрим таблицу
SELECT id, name FROM users_for_task;
