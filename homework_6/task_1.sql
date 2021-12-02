-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

USE shop;

SELECT
	users.id AS user_id ,
	users.name AS user_name,
	orders.id AS order_id
FROM
	users
JOIN
	orders
ON
	users.id  = orders.user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT
	p.id AS products_id,
	p.name AS products_name,
	c.id AS catalog_id,
	c.name AS catalog_name
FROM
	catalogs AS c
LEFT JOIN
	products AS p
ON
	c.id = p.catalog_id

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

SELECT
	f.id AS flight_id,
	c1.name as `from`,
	c2.name as `to`
FROM
	flights as f
JOIN
	cities as c1
ON
	c1.label = f.`from`
JOIN
	cities as c2
ON
	c2.label = f.`to`
ORDER BY f.id;