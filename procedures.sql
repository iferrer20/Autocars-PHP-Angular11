-- TABLAS
DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
	brand_id int AUTO_INCREMENT NOT NULL,
	name varchar(20) NOT NULL,
	PRIMARY KEY (brand_id)
);

DROP TABLE IF EXISTS cars;
CREATE TABLE cars (
	car_id char(17) NOT NULL,
	name varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
	description varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
	km int NOT NULL,
	price int NOT NULL,
	brand int NOT NULL,
	at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	views int NOT NULL DEFAULT 0,
	PRIMARY KEY (car_id),
	FOREIGN KEY (brand) REFERENCES brands(brand_id)
);
-- offroad, sporty, minivan, van
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	category_id int AUTO_INCREMENT NOT NULL,
	name varchar(20) NOT NULL,
	PRIMARY KEY (category_id)
);

INSERT INTO categories (name) VALUES ('offroad');
INSERT INTO categories (name) VALUES ('sporty');
INSERT INTO categories (name) VALUES ('minivan');
INSERT INTO categories (name) VALUES ('van');

DROP TABLE IF EXISTS car_category;
CREATE TABLE car_category (
	car_id char(17) NOT NULL,
	category_id int NOT NULL,
	FOREIGN KEY (car_id) REFERENCES cars(car_id),
	FOREIGN KEY (category_id) REFERENCES categories(category_id),
	PRIMARY KEY (car_id, category_id)
);


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id char(17) PRIMARY KEY NOT NULL,
	email varchar(64) NOT NULL UNIQUE,
	username varchar(20) UNIQUE,
	password char(44),
	privileges ENUM('ADMIN', 'STAFF')
);

DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites (
	user_id char(17) NOT NULL,
	car_id char(17) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (car_id) REFERENCES cars(car_id),
	PRIMARY KEY (user_id, car_id)
);

DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
	user_id char(17) NOT NULL,
	car_id char(17) NOT NULL,
	quantity int NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (car_id) REFERENCES cars(car_id),
	PRIMARY KEY (user_id, car_id)
);

-- PROCEDURES
DROP PROCEDURE IF EXISTS createCar;
DELIMITER $$
CREATE PROCEDURE createCar (
	IN name varchar(20),
	IN description varchar(1000),
	IN km int,
	IN price int,
	IN brand varchar(20)
)
BEGIN
	DECLARE car_id char(17);
	DECLARE brand_id int;

	SELECT b.brand_id INTO brand_id FROM brands AS b WHERE b.brand_id = brand LIMIT 1;

	IF brand_id IS NULL THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Invalid category';
	END IF;

	SET car_id = UUID_SHORT();
	INSERT INTO cars VALUES (car_id, name, description, km, price, brand_id, CURRENT_TIMESTAMP(), 0);

	SELECT car_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteCar;
DELIMITER $$
CREATE PROCEDURE deleteCar (
	IN car_id char(17)
)
BEGIN
	
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS userSignup;
DELIMITER $$
CREATE PROCEDURE userSignup (
	IN email VARCHAR(64), 
	IN username VARCHAR(20), 
	IN password VARCHAR(64)
)
BEGIN
	DECLARE user_id CHAR(17);
	DECLARE salt CHAR(4);
	DECLARE hash CHAR(40);
	DECLARE errstr VARCHAR(255);
	DECLARE err VARCHAR(255);
	DECLARE EXIT HANDLER FOR 1062
	BEGIN
		GET DIAGNOSTICS CONDITION 1 err = MESSAGE_TEXT;
		SET err = REPLACE(SUBSTRING_INDEX(err, '\'', -2), '\'', '');
		CASE err
			WHEN 'email' THEN SET errstr = 'Email already in use';
			WHEN 'username' THEN SET errstr = 'Username already in use';
		END CASE;

		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = errstr;
	END;

	/* VALIDATION */
	IF email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
    	SET errstr = 'Invalid email';
	ELSEIF LENGTH(username) < 5 THEN
		SET errstr = 'Username too short';
	ELSEIF LENGTH(password) < 5 THEN
		SET errstr = 'Password too short';
	ELSEIF username NOT REGEXP '^[a-z0-9_]+$' THEN
		SET errstr = 'Invalid username';
	END IF;

	IF errstr IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = errstr;
	END IF;

	SET salt = SUBSTRING(MD5(RAND()) from 1 for 4);
	SET hash = SHA1(CONCAT(salt, password));
	SET user_id = UUID_SHORT();
	
	INSERT INTO users (user_id, email, username, password) VALUES (user_id, email, username, CONCAT(salt, hash));
	SELECT user_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS userSignin;
DELIMITER $$
CREATE PROCEDURE userSignin (
	IN username VARCHAR(64), 
	IN password VARCHAR(64)
) 
BEGIN
	DECLARE user_id CHAR(17);
	checkHash:BEGIN
		DECLARE hash CHAR(40);
		DECLARE realhash CHAR(40);
		DECLARE salt CHAR(4);
		
		SELECT SUBSTRING(u.password, 1, 4), SUBSTRING(u.password, 5), u.user_id
		INTO salt, realhash, user_id
		FROM users AS u 
		WHERE (u.username = username OR u.email = username) 
		LIMIT 1;

		IF realhash IS NOT NULL THEN
			SET hash = SHA1(CONCAT(salt, password));
			IF NOT STRCMP(hash, realhash) THEN
				LEAVE checkHash;
			END IF;
		END IF;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid username or password';
	END;
	SELECT user_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS userSocialSignin;
DELIMITER $$
CREATE PROCEDURE userSocialSignin (
	IN email varchar(64)
) 
BEGIN
	DECLARE user_id char(17);
	SELECT u.user_id INTO user_id FROM users AS u WHERE u.email = email LIMIT 1;
	IF user_id IS NULL THEN
		SET user_id = UUID_SHORT();
		INSERT INTO users (user_id, email, username, password) VALUES (user_id, email, NULL, NULL);
	END IF;

	SELECT user_id;
END$$
DELIMITER ;


