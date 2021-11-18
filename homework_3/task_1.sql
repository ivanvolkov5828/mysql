-- 1. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице).

USE vk;

-- посмотрим, какие есть таблицы в базе данных
SHOW tables;

-- посмотрим таблицу users
SELECT id, firstname, lastname, email, password_hash, phone, is_deleted FROM users;

-- наполним ее данными пакетной вставкой (сайт filldb.info не работал)
INSERT INTO users(firstname, lastname, email, password_hash, phone, is_deleted)
VALUES
('Lupe', 'Cassin', 'arlo1@example.org', 'ab3nwaxk', '911789356', 0),
('Florine', 'Hills', 'arlo2@example.org', 'ab412nxk', '911723756', 0),
('Samir', 'Yost', 'arlo3@example.org', 'hdjwka32', '989333567', 0),
('Susan', 'O\'Conner', 'arlo4@example.org', 'jdskal42', '911356729', 0),
('Tyree', 'Nienow', 'arlo5@example.org', 'ncdkosl3', '923457881', 0),
('Damon', 'Parker', 'arlo6@example.org', 'masklxmskal3', '916183925', 1);

-- проверим данные
SELECT id, firstname, lastname, email, password_hash, phone, is_deleted FROM users;

-- наполним таблицу profiles
INSERT INTO profiles
VALUES
(3, 'M', FROM_UNIXTIME(RAND() * 2147483647),  NOW(), 'New York'),
(4, 'F', FROM_UNIXTIME(RAND() * 2147483647),  NOW(), 'Washington'),
(1, 'M', FROM_UNIXTIME(RAND() * 2147483647),  NOW(), 'Washington'),
(2, 'F', FROM_UNIXTIME(RAND() * 2147483647),  NOW(), 'Los Angeles'),
(6, 'M', FROM_UNIXTIME(RAND() * 2147483647),  NOW(), 'New York'),
(5, 'M', FROM_UNIXTIME(RAND() * 2147483647),  NOW(), 'Сhicago');

-- наполним таблицу messages
INSERT INTO messages
VALUES
(1, 1, 2, 'Hello! How are you?', default),
(2, 3, 4, 'Nooooo!', default),
(3, 5, 6, 'Seriously?', default),
(4, 4, 1, 'We are friends with him', default);

-- наполним таблицу friend_requests
INSERT INTO friend_requests
VALUES
(1, 2, 'requested', default, NOW()),
(1, 3, 'requested', default, NOW()),
(3, 2, 'requested', default, NOW()),
(6, 4, 'requested', default, NOW());

-- наполним таблицу communities
INSERT INTO communities
VALUES
(1, 'Bi-Polarity', 3),
(2, 'Тигрулечка', 1),
(3, 'Кафедра ИУ1', 2);

-- наполним таблицу users_communities
INSERT INTO users_communities
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 3),
(5, 2);

-- 2. Написать скрипт, возвращающий список имен (только firstname) пользователей
-- без повторений в алфавитном порядке.

SELECT DISTINCT firstname FROM users ORDER BY firstname;

-- 3. Первые пять пользователей пометить как удаленные.

UPDATE users
SET
	is_deleted = 1
LIMIT 5;

select * from users;

-- 4. Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней).

--  Поставим сообщению с id 3 дату из будущего
UPDATE messages
	SET created_at='2226-02-27 05:03:11'
	WHERE id = 3;

-- Удалим сообщение из будущего
DELETE FROM messages
WHERE created_at > now()
;

-- 5. Написать название темы курсового проекта.
-- официальный сайт МГТУ имени Н. Э. Баумана