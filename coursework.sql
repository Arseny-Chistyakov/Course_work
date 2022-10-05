-- Создание базы, таблиц
--  DROP DATABASE hospital;
DROP DATABASE IF EXISTS hospital;
CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

DROP TABLE IF EXISTS `diagnosis`;		
CREATE TABLE `diagnosis` (				
	id serial PRIMARY KEY,
	doctors_id BIGINT UNSIGNED NOT NULL ,
	disease VARCHAR(100),
	death_or BIT DEFAULT 0 COMMENT 'Смертельно ли?' 
);

DROP TABLE IF EXISTS `doctors`;		
CREATE TABLE `doctors` (		
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100),
    lastname VARCHAR(100),
	post_id BIGINT UNSIGNED NOT NULL,
    gender CHAR(1),
    birthday DATE,
	employment_date DATE COMMENT 'Время приема на работу',
	sector_id BIGINT UNSIGNED NOT NULL
); 

DROP TABLE IF EXISTS `patients`;	
CREATE TABLE `patients` (
	id SERIAL PRIMARY KEY,
	doctors_id BIGINT UNSIGNED NOT NULL COMMENT 'Лечащий врач',
	firstname VARCHAR(100),
    lastname VARCHAR(100), 
    gender CHAR(1),
    birthday DATE,
	phone BIGINT,
	book BIT default 1 COMMENT 'Медкнижка', 
	street_id BIGINT UNSIGNED NOT NULL
);  

DROP TABLE IF EXISTS `post`;		-- 'Должность'
CREATE TABLE `post` (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50)
); 

DROP TABLE IF EXISTS `sector`;
CREATE TABLE `sector` (
	id SERIAL PRIMARY KEY COMMENT 'Номер района',
	name VARCHAR(100)
);

DROP TABLE IF EXISTS `streets`; 
CREATE TABLE `streets` (
	id SERIAL PRIMARY KEY COMMENT 'Номер улицы',
	name VARCHAR(100),
	sector_id BIGINT UNSIGNED NOT NULL
);

DROP TABLE IF EXISTS `survey_results`;		-- 'Результаты обследования'
CREATE TABLE `survey_results` (				
	diag_id BIGINT UNSIGNED NOT NULL,
	patients_id BIGINT UNSIGNED NOT NULL,
	doctors_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (patients_id, doctors_id, diag_id),
	date_appointment DATE COMMENT 'Дата приема'
); 

DROP TABLE IF EXISTS `talon`;
CREATE TABLE `talon` (
	patients_id BIGINT UNSIGNED NOT NULL,
	doctors_id BIGINT UNSIGNED NOT NULL,
	post_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (patients_id, doctors_id ),
 	`date` DATE,
	time VARCHAR(50)
);

DROP TABLE IF EXISTS `timetable`;		-- 'Расписание'
CREATE TABLE `timetable` (			
	doctors_id BIGINT UNSIGNED NOT NULL,
	post_id BIGINT UNSIGNED NOT NULL,
	time_appointment TEXT COMMENT 'Время приема',
	room_number TINYINT UNSIGNED NOT NULL COMMENT 'Номер кабинета',
	PRIMARY KEY (post_id, doctors_id )
);

-- Создание связей между таблицами
ALTER TABLE streets ADD CONSTRAINT 
FOREIGN KEY (sector_id) REFERENCES sector(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE patients ADD CONSTRAINT 
FOREIGN KEY (street_id) REFERENCES streets(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE patients ADD CONSTRAINT 
FOREIGN KEY (doctors_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE timetable ADD CONSTRAINT 
FOREIGN KEY (doctors_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE timetable ADD CONSTRAINT 
FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE survey_results ADD CONSTRAINT 
FOREIGN KEY (patients_id) REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE survey_results ADD CONSTRAINT 
FOREIGN KEY (diag_id) REFERENCES diagnosis(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE survey_results ADD CONSTRAINT 
FOREIGN KEY (doctors_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE talon ADD CONSTRAINT 
FOREIGN KEY (doctors_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE talon ADD CONSTRAINT 
FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE talon ADD CONSTRAINT
FOREIGN KEY (patients_id) REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE doctors ADD CONSTRAINT 
FOREIGN KEY (sector_id) REFERENCES sector(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE doctors ADD CONSTRAINT 
FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE diagnosis ADD CONSTRAINT 
FOREIGN KEY (doctors_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- Заполнение таблиц
SET FOREIGN_KEY_CHECKS=0;

INSERT IGNORE INTO diagnosis
  (id, doctors_id, disease, death_or)
VALUES
	(1, 1,'ОРВ', 0),
	(2, 2,'Холера', 1),
	(3, 1,'Бессоница', 0),
	(4, 3,'Рак', 1),
	(5, 4,'Инсульт', 1),
	(6, 5,'Изжога', 0),
	(7, 6,'Чума', 1),
	(8, 7,'Кариес', 0),
	(9, 8,'Депрессия', 0),
	(10, 9,'Деменция', 1);

INSERT IGNORE INTO doctors 
  (id, firstname, lastname, post_id,gender, birthday, employment_date, sector_id)
VALUES
	(1,'Александр','Писков', 1 , 'м', '1976-07-24','1996-07-24', 1),
	(2,'Таисия','Щекочихина',2,'ж', '1979-08-28','1997-07-24', 2),
	(3,'Мила','Курепина', 3 , 'ж', '1956-02-27','1996-01-11', 2),
	(4,'Валентин','Заболотный', 4 , 'м', '1976-07-24','2000-07-24',3),
	(5,'Юрий','Куксилов', 5 , 'м', '1976-07-24','2006-07-24', 1),
	(6,'Анастасия','Белорусова', 6 , 'ж', '1976-07-24','2007-07-24', 3),
	(7,'Александр','Яматин', 7 , 'м', '1999-07-24','2003-07-24', 4),
	(8,'Даниил','Кумиров', 8 , 'м', '1988-07-24','1986-07-24', 5),
	(9,'Алина','Чуличкова', 9 , 'ж', '1977-06-24','1999-07-24', 5),
	(10,'Виктор','Бехтерев',10 , 'м', '1964-01-24','1998-07-24', 5),
	(11,'Марина','Шеповалова', 1 , 'ж', '1949-07-24','1995-07-24', 3),
	(12,'Кирилл','Таначёв', 4 , 'м', '1966-07-24','2000-07-24', 2),
	(13,'Надежда','Ласкутина', 3 , 'ж', '1956-07-24','2021-07-24', 1),
	(14,'Петр','Брантов', 4 , 'ж', '1946-07-24','2003-07-24', 4),
	(15,'Лаврентий','Горяинов', 4 , 'м', '1936-07-24','2005-07-24', 1);

INSERT IGNORE INTO patients
  (id, doctors_id, firstname, lastname, gender, birthday, phone, book, street_id)
VALUES
	(1,15,'Валерия', 'Приходько', 'ж', '2001-09-28', 89691013718, 1, 100),
	(2,13, 'Елена', 'Пискова','ж', '2000-08-28', 89895266782, 0, 101),
	(3,12,'Светлана', 'Волкова', 'ж', '2005-09-28', 89691883718, 1, 102),
	(4,5,'Руслан ', 'Пипов', 'м', '2002-04-28', 89111013718, 0, 103),
	(5,1,'Ева', 'Волкова', 'ж', '2012-09-28', 89691456718, 1, 104),
	(6,11,'Борис', 'Еренко', 'м', '2016-09-28', 89691324718, 1, 105),
	(7,10,'Юлия', 'Попова', 'ж', '2002-09-28', 89691056718, 0, 106),
	(8,11,'Елена', 'Приходько', 'ж', '2003-09-28', 89691233718, 1, 107),
	(9,2,'Арсений', 'Боткин', 'м', '2001-09-22', 89691735718, 0, 108),
	(10,14,'Анна', 'Волкова', 'ж', '2011-02-28', 89623513718, 0, 109),
	(11,13,'Иван', 'Мельник', 'м', '2001-10-31', 89691011238, 1, 102),
	(12,1,'Артем', 'Кушко', 'м', '2006-02-28', 89691084518, 0, 100),
	(13,4,'Елена', 'Курепина', 'ж', '2010-09-28', 89131013718, 1, 103),
	(14,6,'Надежда', 'Кувалова', 'ж', '2001-08-10', 89691013718, 1, 103),
	(15,8,'Светлана', 'Чистякова', 'ж', '2001-07-11', 89691013718, 0, 102),
	(16,10,'Егор', 'Евтодиков', 'м', '2001-06-12', 89691113718, 1, 105),
	(17,12,'Михаил', 'Пушков', 'м', '2000-05-13', 89691213718, 0, 104),
	(18,14,'Александр', 'Егоров', 'м', '2002-04-14', 89691313718, 0, 104),
	(19,13,'Олеса', 'Тупорова', 'ж', '2003-03-15', 89694213718, 0, 100),
	(20,11,'Оксана', 'Швеякова', 'ж', '2001-02-16', 89694413718, 0, 102);

INSERT IGNORE INTO post
  (id, name) 
VALUES
	(1,'Хирург'),
	(2,'Офтальмолог'),
	(3,'Терапевт'),
	(4,'Стоматолог'),
	(5,'Педиатр'),
	(6,'Нарколог'),
	(7,'Невролог'),
	(8,'Диетолог'),
	(9,'Травматолог'),
	(10,'Уролог');

INSERT IGNORE INTO sector 
  (id, name) 
VALUES
	(1,'Северный'),
	(2,'Западный'),
	(3,'Южный'),
	(4,'Центральный'),
	(5,'Восточный');

INSERT IGNORE INTO streets 
  (sector_id, name,id) 
VALUES
	(1,'Ченцова',100),
	(1,'Пушкинская',101),
	(3,'Лесная',102),
	(4,'Чехова',103),
	(5,'Восточная',104),
	(1,'Степанцева',105),
	(2,'Тельмана',106),
	(3,'Королева',107),
	(4,'Гагарина',108),
	(5,'Семашко ',109);

INSERT IGNORE INTO survey_results 
	(diag_id , patients_id,doctors_id, date_appointment) 
VALUES
	(2,1,1,'2021-06-12'),
	(9,2,10,'2021-06-12'),
	(9,12,7,'2021-06-12'),
	(9,18,7,'2021-06-12'),
	(10,3,6,'2021-06-12'),
	(1,15,5,'2021-06-12'),
	(2,20,4,'2021-06-12'),
	(6,19,3,'2021-06-12'),
	(8,11,2,'2021-06-12'),
	(4,10,1,'2021-06-12');

INSERT IGNORE INTO talon 
  (doctors_id , post_id , patients_id, `date`, `time`) 
VALUES
	(4,3,1,'2021-06-20', '7:30'),
	(2,10,12,'2021-05-21', '8:30'),
	(10,1,18,'2021-04-22', '8:30'),
	(9,8,13,'2021-03-23', '9:30'),
	(8,6,2,'2021-02-24', '10:30'),
	(7,4,6,'2021-01-25', '9:30'),
	(6,2,7,'2021-02-26', '11:30'),
	(5,1,16,'2021-03-27', '10:30'),
	(4,3,3,'2021-04-28', '8:30'),
	(3,5,17,'2021-05-12', '7:30'),
	(2,7,11,'2021-06-10', '16:30'),
	(1,9,19,'2021-07-12', '18:30');

INSERT IGNORE INTO timetable 
  (doctors_id, post_id, time_appointment, room_number) 
VALUES
	(15,1,'7:00 - 13:00', 101),
	(14,2,'10:00 - 19:00', 204),
	(13,5,'8:00 - 18:00', 178),
	(12,10,'8:00 - 13:00', 123),
	(11,9,'8:00 - 16:00', 110),
	(10,8,'12:00 - 18:00', 125),
	(9,5,'7:00 - 19:00', 114),
	(8,5,'13:00 - 18:00', 194),
	(7,6,'9:00 - 14:00', 111),
	(6,7,'11:00 - 13:00', 127),
	(5,6,'7:00 - 17:00', 139),
	(4,5,'8:00 - 11:00', 147),
	(3,1,'8:00 - 20:00', 129),
	(2,2,'8:00 - 18:00', 134),
	(1,3,'7:00 - 12:00', 176);

SET FOREIGN_KEY_CHECKS=1;
	
-- Запросы
-- вывести всех врачей живущих в восточном районе
SELECT 
	d.id ,
	CONCAT(d.firstname, ' ', d.lastname) 'Имя Фамилия',
	s.name 'Район'
		FROM doctors d 
			JOIN sector s ON sector_id = s.id 
	WHERE s.name LIKE 'Восточный'
ORDER BY d.firstname;


-- вывести пациентов со смертельным диагнозом 
SELECT 
	p.id ,
	p.firstname 'Имя', 
	p.lastname 'Фамилия',
	d.disease 'Название болезни',
	d.id 'Номер болезни'
		FROM patients p 
			JOIN diagnosis d ON d.id = p.id
	WHERE d.death_or = 1
ORDER BY p.firstname, d.id;


-- Вывести всех стомалогов мужчин
SELECT 
	d.firstname 'Имя', 
	d.lastname 'Фамилия',
	p.name 'Должность'
		FROM doctors d 
			JOIN post p ON p.id = d.post_id 
	WHERE p.name = 'Стоматолог' AND d.gender = 'м'
ORDER BY d.firstname;
	
	
-- посмотреть самого востребованного специалиста на данный момент по расписанию 
SELECT 
	p.name 'Должность',
	COUNT(p.id) 'Кол-во записей в расписании'
	FROM post p 
			JOIN timetable t on t.post_id = p.id 
	GROUP BY p.id
ORDER BY COUNT(p.id) DESC;


-- вывести пациентов старше 19 лет и их лечащих врачей 
SELECT 
	p.id ,
	p.firstname 'Имя пациента',
	(YEAR(CURRENT_DATE)-YEAR(p.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(p.birthday,5)) age,
	CONCAT(d.firstname, ' ', d.lastname) AS 'Леч. врач'
		FROM patients p 
			JOIN doctors d ON d.id = p.doctors_id 
	WHERE timestampdiff(YEAR, p.birthday, NOW())> 19
ORDER BY age DESC, p.firstname; 


-- вывести пациентов, запись которых раньше мая 
SELECT  
	p.id ,
	p.firstname 'Имя пациента',
	t.`date`  'Дата записи'
		FROM talon t 
			JOIN patients p ON p.id = t.patients_id 
	WHERE MONTH(t.`date`)<5
ORDER BY t.`date` DESC;



-- Создание представлений
-- Представление таблицы "talon"
CREATE OR REPLACE VIEW v_talon as
SELECT 
	p.firstname 'Имя пац.',
	p.lastname 'Фамилия пац.',
	d.lastname 'Фамилия врача',
	p2.name 'Должжность',
	t.`date` ' Дата приема',
	t.`time` ' Время прием'
		FROM talon t 
			JOIN patients p ON t.patients_id = p.id 
			JOIN doctors d ON d.id = t.doctors_id 
			JOIN post p2 ON p2.id = t.post_id 
ORDER BY p.firstname;


-- Представление таблицы "timetable"
CREATE OR REPLACE VIEW v_timetable as
SELECT 
	d.firstname 'Имя',
	d.lastname 'Фамилия',
	p.name 'Должжность',
	t.time_appointment 'Приемные часы',
	t.room_number 'Номер кабинета'
		FROM timetable t 
			JOIN doctors d ON d.id = t.doctors_id 
			JOIN post p ON p.id = t.post_id 
ORDER BY d.firstname;


-- Процедура для вставки пациента
DROP PROCEDURE IF EXISTS hospital.sp_patients_add;	
DELIMITER //
CREATE PROCEDURE sp_patients_add(
	id BIGINT UNSIGNED,
	doctors_id BIGINT UNSIGNED,
	firstname VARCHAR(100),
    lastname VARCHAR(100), 
    gender CHAR(1),
    birthday DATE,
	phone BIGINT,
	book BIT , 
	street_id BIGINT UNSIGNED)
	BEGIN
INSERT INTO patients
(patients.id , patients.doctors_id, patients.firstname, patients.lastname, patients.gender, patients.birthday, patients.phone, patients.book, patients.street_id)
VALUES (id, doctors_id, firstname, lastname, gender, birthday, phone,book, street_id); 
	END//
DELIMITER ;

CALL sp_patients_add(21,12, 'Валентина', 'Прохорова','ж', '2011-08-28', 89892226782, 1, 101);

DELETE FROM patients WHERE patients.id =21;


-- Процедура для удаления врача по его ID
DROP PROCEDURE IF EXISTS hospital.sp_doctors_del;	
DELIMITER //
CREATE PROCEDURE sp_doctors_del(
id integer)
	BEGIN
DELETE FROM doctors WHERE doctors.id = id;
	END//
DELIMITER ;

CALL sp_doctors_del(2);

INSERT INTO doctors 
VALUES (2,'Таисия','Щекочихина',2,'ж', '1979-08-28','1997-07-24', 2);


-- Триггер на добавления несуществующего доктора в таблице "Пациенты"
DROP TRIGGER IF EXISTS t_add_pat;
DELIMITER //
CREATE TRIGGER t_add_pat BEFORE INSERT ON patients
FOR EACH ROW
	BEGIN
		IF NEW.doctors_id > (Select Count(id) From doctors) THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Такого доктора не существует!';
		END IF; 
	END//
DELIMITER ;

-- Проверка триггера
INSERT INTO hospital.patients 
(patients.id , patients.doctors_id, patients.firstname, patients.lastname, patients.gender,
patients.birthday, patients.phone, patients.book, patients.street_id)
VALUES (21,222222, 'Валентина', 'Прохорова','ж', '2011-08-28', 89892226782, 1, 101);


-- Триггер на логирование удаления записей
DROP TABLE IF EXISTS logs; 
CREATE TABLE _logs (
	table_name VARCHAR(39),
	id BIGINT UNSIGNED,
	doctors_id BIGINT UNSIGNED,
	firstname VARCHAR(100),
    lastname VARCHAR(100), 
    gender CHAR(1),
    birthday DATE
) ENGINE=Archive;

DROP TRIGGER IF EXISTS t_del_note;
DELIMITER //
CREATE TRIGGER t_del_note AFTER DELETE ON patients
FOR EACH ROW
	BEGIN
		INSERT INTO logs(table_name,id,doctors_id,firstname,lastname,gender,birthday)
		VALUES ('patients', OLD.id, OLD.doctors_id, OLD.firstname , OLD.lastname , OLD.gender , OLD.birthday);
	END//
DELIMITER ;

-- Проверка тригерра
DELETE FROM patients WHERE patients.id =7;
DELETE FROM patients WHERE patients.id =2;
DELETE FROM patients WHERE patients.id =13;

