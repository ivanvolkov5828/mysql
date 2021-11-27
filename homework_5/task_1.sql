-- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

Use vk;

SHOW TABLES FROM vk;

-- смотрю друзей у пользователя с id = 1
SELECT initiator_user_id, target_user_id, status, requested_at, updated_at FROM friend_requests;

-- сделаю так, чтобы у пользователя с id = 1 появились друзья c id = 2 и id = 3
UPDATE friend_requests
SET
	status = 'approved'
WHERE
	initiator_user_id  = 1;

-- смотрю сообщения у пользователя с id = 1
SELECT from_user_id, to_user_id,body FROM messages
WHERE from_user_id = 1;

-- добавлю в эту таблицу еще сообщений с пользователем id=1 для реализации поставленной задачи
INSERT INTO messages
VALUES
	(5, 1, 2, 'this is the second message', NOW()),
	(6, 1, 2, 'Why do not you answer ?', NOW()),
	(7, 1, 2, 'Are you offended by me?', NOW()),
	(8, 1, 3, 'We had a great party yesterday', NOW()),
	(9, 1, 3, 'You won\'t believe it! The user with id = 2 does not respond to me', NOW());

-- реализация
SELECT
    -- пользователь, сообщения с которым нас интересуют
    from_user_id,
    -- пользователи, с которыми общается наш пользователь
    to_user_id,
    -- количество сообщений с данными пользователями
	COUNT(*) as 'number_of_messages'
-- берем данные из таблицы messages где получатель сообщений(to_user_id) может быть нескольких вариантов
-- внутренний запрос находит пользователей, которые приняли дружбу от пользователя с id = 1
FROM messages WHERE to_user_id IN (SELECT target_user_id FROM friend_requests WHERE initiator_user_id = 1 AND status = 'approved')
-- группируем по этим пользователям
GROUP BY to_user_id
-- выводим в порядке убывания количество сообщений
ORDER BY COUNT(*) DESC
-- сделаем ограничение на 1 строку, чтобы выводил нужного пользователя и нужное количество сообщений
LIMIT 1;

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.

INSERT INTO media_types
VALUES
	(1, 'Photo', NOW(), NOW()),
	(2, 'Video', NOW(), NOW()),
	(3, 'Post',  NOW(), NOW()),
	(4, 'Music', NOW(), NOW());

INSERT INTO media
VALUES
	(1, 1, 1, 'какая-то фотография', 'a.jpeg', 5, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(2, 2, 1, 'какое-то видео', 'b.mp4', 8, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(3, 1, 2, 'какое-то фото', 'c.mp4', 6, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(4, 2, 2, 'какое-то видео', 'd.jpeg', 6, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW());

INSERT INTO likes
VALUES
    -- первый пользователь поставил лайк фотке пользователю с id = 2
	(1, 1, 3, FROM_UNIXTIME(RAND() * 2147483647)),
	-- первый пользователь поставил лайк видео пользователю с id = 2
	(2, 1, 4, FROM_UNIXTIME(RAND() * 2147483647)),
	-- второй пользователь поставил лайк фотке пользователю с id = 1
	(3, 2, 1, FROM_UNIXTIME(RAND() * 2147483647)),
	-- второй пользователь поставил лайк видео пользователю с id = 1
	(4, 2, 2, FROM_UNIXTIME(RAND() * 2147483647));


-- реализация
SELECT
	COUNT(*) AS 'number_of_likes'
FROM likes
WHERE media_id IN(SELECT id FROM media WHERE user_id IN(SELECT user_id FROM profiles WHERE (YEAR(NOW()) - YEAR(birthday) < 10) AND (YEAR(birthday) <= YEAR(NOW()))));


-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины


select * from profiles;

-- пользователь id = 1 и id = 2 разных полов, добавлю от них записей в media

INSERT INTO media
VALUES
	(5, 4, 1, 'веселая песня', 'd.mp3', 3, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(6, 4, 1, 'Listen To Your Heart', 'e.mp3', 2, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(7, 4, 1, 'Cheri Cheri Lady', 'f.mp3', 7, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(8, 3, 2, 'Короновирус', '.txt', 1, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW()),
	(9, 1, 2, 'Фото с отдыха', 'ja;lcs.jpeg', 3, NULL, FROM_UNIXTIME(RAND() * 2147483647), NOW());

INSERT INTO likes
VALUES
-- второй пользователь лайкнул все посты первого
	(5, 2, 5, FROM_UNIXTIME(RAND() * 2147483647)),
	(6, 2, 6, FROM_UNIXTIME(RAND() * 2147483647)),
	(7, 2, 7, FROM_UNIXTIME(RAND() * 2147483647)),
-- первый пользователь лайкнул только один
	(8, 1, 8, FROM_UNIXTIME(RAND() * 2147483647));

-- реализация
SELECT
    COUNT(*) as 'number_of_likes',
	(SELECT gender FROM profiles WHERE user_id = likes.user_id ) as 'gender',
	user_id
FROM likes
GROUP BY user_id
ORDER BY COUNT(*) DESC;

-- наверное, можно было бы решить более правильно, но я решил так :)
