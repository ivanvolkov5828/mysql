-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

-- используем базу данных shop
USE shop;

-- меняем ; на //
DELIMITER //
-- удаляем функцию в случае существования
DROP FUNCTION IF EXISTS hello//
-- создаем функцию
CREATE FUNCTION hello ()
-- тип возвращаемого значения
RETURNS TINYTEXT DETERMINISTIC
BEGIN
	-- переменная
	DECLARE time_now INT;
	-- переменная равна времени в данный момент, выделяем конкретно час
	SET time_now = HOUR(NOW());
	CASE
		-- между 6 и 12
		WHEN time_now BETWEEN 6 AND 12 THEN
			RETURN "Доброе утро";
		-- между 12 и 18
		WHEN time_now BETWEEN 12 AND 18 THEN
			RETURN "Добрый день";
		-- между 18 и 0
		WHEN time_now BETWEEN 18 AND 0 THEN
			RETURN "Добрый вечер";
		-- между 0 и 6
		WHEN time_now BETWEEN 0 AND 6 THEN
			RETURN "Доброй ночи";
	END CASE;
END//

DELIMITER ;

SELECT hello() as greeting;

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение
--  необходимо отменить операцию.

DROP TRIGGER IF EXISTS null_trigger;
delimiter //
CREATE TRIGGER null_trigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(NEW.name IS NULL AND NEW.description IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! NULL in both fields!';
	END IF;
END //
delimiter ;

-- оба NULL
INSERT INTO products (name, description)
VALUES (NULL, NULl);
-- одно NULL
INSERT INTO products (name, description)
VALUES ("GeForce GTX 1080", NULL);
-- оба значения нормальные
INSERT INTO products (name, description)
VALUES ("GeForce GTX 1080", "Мощная видеокарта");

SELECT * from products;

-- 3. по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

DELIMITER //
-- удаляем функцию в случае существования
DROP FUNCTION IF EXISTS fibonacci//
-- создаем функцию
CREATE FUNCTION fibonacci(value INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE i INT DEFAULT 0;
	DECLARE fib1 INT;
	DECLARE fib2 INT;
	DECLARE fib_sum INT;


	SET fib1 = 1;
	SET fib2 = 1;
	SET fib_sum = 0;

	WHILE i < (value - 2) DO
		SET fib_sum = fib1 + fib2;
		SET fib1 = fib2;
		SET fib2 = fib_sum;
		SET i = i + 1;
	END WHILE;

	RETURN  fib2;

END//
DELIMITER ;

SELECT fibonacci(10) as fibonacci;

-- Практическое задание по теме “Транзакции, переменные, представления”

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE shop.users.id = 1);
COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и
-- соответствующее название каталога name из таблицы catalogs.

DROP VIEW IF EXISTS cat;
CREATE VIEW cat
AS SELECT
	p.name,
	c.name as catalogs
FROM products p
JOIN catalogs c
ON c.id = p.catalog_id;

SELECT name, catalogs FROM cat;

-- 3. по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи
-- за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август,
--  выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

DROP TABLE IF EXISTS task3;
CREATE TABLE task3 (
  id SERIAL PRIMARY KEY,
  created_at DATE);
INSERT INTO task3 VALUES
  (NULL, '2018-08-01'), (NULL, '2018-08-04'), (NULL, '2018-08-16'), (NULL, '2018-08-17');

CREATE TEMPORARY TABLE days_aug (days INT);

INSERT INTO days_aug VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
							(11), (12),(13),(14), (15), (16), (17), (18), (19), (20),
                            (21), (22), (23), (24), (25), (26), (27), (28), (29), (30), (31);
-- Можно ли даты месяца в цикле заполнить?

SET @start_aug = '2018-07-31';

SELECT @start_aug + INTERVAL days DAY AS date_aug,
	   CASE WHEN task3.created_at IS NULL THEN 0 ELSE 1 END AS v1 FROM days_aug
LEFT JOIN task3 ON @start_aug + INTERVAL days DAY = task3.created_at
ORDER BY date_aug;

-- Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)

-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на
-- чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

USE shop;

DROP USER IF EXISTS shop;
CREATE USER shop IDENTIFIED WITH sha256_password BY 'pass';
GRANT ALL ON shop.* TO shop;

DROP USER IF EXISTS shop_read;
CREATE USER shop_read IDENTIFIED WITH sha256_password BY 'pass';
GRANT SELECT ON shop.* TO shop_read;

-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ,
-- имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id
-- и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.


DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	name VARCHAR (50),
	password VARCHAR(50)
);

DROP VIEW IF EXISTS username;
CREATE VIEW username(id, name) AS
SELECT id, name FROM accounts;

DROP USER IF EXISTS user_read;
CREATE USER user_read;
GRANT SELECT ON shop.accounts TO user_read;
