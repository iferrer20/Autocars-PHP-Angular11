-- TABLAS
DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
	brand_id INT AUTO_INCREMENT NOT NULL,
	name VARCHAR(20) NOT NULL,
	PRIMARY KEY (brand_id)
);

INSERT INTO brands (name) VALUES ('Audi');
INSERT INTO brands (name) VALUES ('BMW');
INSERT INTO brands (name) VALUES ('Buick');
INSERT INTO brands (name) VALUES ('Cadillac');
INSERT INTO brands (name) VALUES ('Chevrolet');
INSERT INTO brands (name) VALUES ('Chrysler');
INSERT INTO brands (name) VALUES ('Dodge');
INSERT INTO brands (name) VALUES ('Ferrari');
INSERT INTO brands (name) VALUES ('Ford');
INSERT INTO brands (name) VALUES ('GM');
INSERT INTO brands (name) VALUES ('GEM');
INSERT INTO brands (name) VALUES ('GMC');
INSERT INTO brands (name) VALUES ('Honda');
INSERT INTO brands (name) VALUES ('Hummer');
INSERT INTO brands (name) VALUES ('Hyundai');
INSERT INTO brands (name) VALUES ('Infiniti');
INSERT INTO brands (name) VALUES ('Isuzu');
INSERT INTO brands (name) VALUES ('Jaguar');
INSERT INTO brands (name) VALUES ('Jeep');
INSERT INTO brands (name) VALUES ('Kia');
INSERT INTO brands (name) VALUES ('Lamborghini');
INSERT INTO brands (name) VALUES ('Land Rover');
INSERT INTO brands (name) VALUES ('Lexus');
INSERT INTO brands (name) VALUES ('Lincoln');
INSERT INTO brands (name) VALUES ('Lotus');
INSERT INTO brands (name) VALUES ('Mazda');
INSERT INTO brands (name) VALUES ('Mercedes-Benz');
INSERT INTO brands (name) VALUES ('Mercury');
INSERT INTO brands (name) VALUES ('Mitsubishi');
INSERT INTO brands (name) VALUES ('Nissan');
INSERT INTO brands (name) VALUES ('Oldsmobile');
INSERT INTO brands (name) VALUES ('Peugeot');
INSERT INTO brands (name) VALUES ('Pontiac');
INSERT INTO brands (name) VALUES ('Porsche');
INSERT INTO brands (name) VALUES ('Regal');
INSERT INTO brands (name) VALUES ('Saab');
INSERT INTO brands (name) VALUES ('Saturn');
INSERT INTO brands (name) VALUES ('Subaru');
INSERT INTO brands (name) VALUES ('Suzuki');
INSERT INTO brands (name) VALUES ('Toyota');
INSERT INTO brands (name) VALUES ('Volkswagen');
INSERT INTO brands (name) VALUES ('Volvo');

DROP TABLE IF EXISTS cars;
CREATE TABLE cars (
	car_id CHAR(17) NOT NULL,
	name VARCHAR(20) COLLATE utf8mb4_unicode_ci NOT NULL,
	description VARCHAR(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
	km INT NOT NULL,
	price INT NOT NULL,
	brand INT NOT NULL,
	at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	views INT NOT NULL DEFAULT 0,
	PRIMARY KEY (car_id),
	FOREIGN KEY (brand) REFERENCES brands(brand_id)
);
-- offroad, sporty, minivan, van
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	category_id INT AUTO_INCREMENT NOT NULL,
	name VARCHAR(20) NOT NULL,
	PRIMARY KEY (category_id)
);

INSERT INTO categories (name) VALUES ('offroad');
INSERT INTO categories (name) VALUES ('sporty');
INSERT INTO categories (name) VALUES ('minivan');
INSERT INTO categories (name) VALUES ('van');

DROP TABLE IF EXISTS car_category;
CREATE TABLE car_category (
	car_id CHAR(17) NOT NULL,
	category_id int NOT NULL,
	FOREIGN KEY (car_id) REFERENCES cars(car_id),
	FOREIGN KEY (category_id) REFERENCES categories(category_id),
	PRIMARY KEY (car_id, category_id)
);


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id CHAR(17) PRIMARY KEY NOT NULL,
	email VARCHAR(64) NOT NULL UNIQUE,
	username VARCHAR(20) UNIQUE,
	password CHAR(44),
	privileges ENUM('ADMIN', 'STAFF')
);

DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites (
	user_id CHAR(17) NOT NULL,
	car_id CHAR(17) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (car_id) REFERENCES cars(car_id),
	PRIMARY KEY (user_id, car_id)
);

DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
	user_id CHAR(17) NOT NULL,
	car_id CHAR(17) NOT NULL,
	quantity INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (car_id) REFERENCES cars(car_id),
	PRIMARY KEY (user_id, car_id)
);


-- PROCEDURES
DROP PROCEDURE IF EXISTS createCar;
DELIMITER $$
CREATE PROCEDURE createCar (
	IN name VARCHAR(20),
	IN description VARCHAR(1000),
	IN km INT,
	IN price INT,
	IN brand VARCHAR(20)
)
BEGIN
	DECLARE car_id CHAR(17);
	DECLARE brand_id INT;

	SELECT b.brand_id INTO brand_id FROM brands AS b WHERE b.name = brand LIMIT 1;

	IF brand_id IS NULL THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Invalid brand';
	END IF;

	SET car_id = UUID_SHORT();
	INSERT INTO cars VALUES (car_id, name, description, km, price, brand_id, CURRENT_TIMESTAMP(), 0);

	SELECT car_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteCar;
DELIMITER $$
CREATE PROCEDURE deleteCar (
	IN car_id CHAR(17)
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

DROP PROCEDURE IF EXISTS userSetPrivilege;
CREATE PROCEDURE userSetPrivilege (
	IN user_id CHAR(17)
)
BEGIN

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
	IN email VARCHAR(64)
) 
BEGIN
	DECLARE user_id CHAR(17);
	SELECT u.user_id INTO user_id FROM users AS u WHERE u.email = email LIMIT 1;
	IF user_id IS NULL THEN
		SET user_id = UUID_SHORT();
		INSERT INTO users (user_id, email, username, password) VALUES (user_id, email, NULL, NULL);
	END IF;

	SELECT user_id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS searchCar;
DELIMITER $$
CREATE PROCEDURE searchCar(
	IN text VARCHAR(128),
	IN min_km INT,
	IN max_km INT,
	IN categories VARCHAR(128),
	IN brand VARCHAR(20),
	IN published TIMESTAMP,
	IN page INT
)
BEGIN
	DECLARE brand_id INT;
	DECLARE offs INT;
	DECLARE ncategories INT;
	DECLARE categories_regexp VARCHAR(255);

	IF categories <> '' THEN -- Check categories
		SET categories_regexp = CONCAT('^', REPLACE(categories, ',', '$|^'), '$');
		SET ncategories = LENGTH(categories) - LENGTH(REPLACE(categories, ',', '')) + 1;
		IF NOT categories REGEXP '^[0-9a-zA-Z_, ]+$' OR (SELECT COUNT(*) FROM categories WHERE name REGEXP categories_regexp) <> ncategories THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Invalid categories';
		END IF;
	END IF;

	IF brand <> '' THEN 
		SELECT b.brand_id INTO brand_id FROM brands AS b WHERE b.name = brand LIMIT 1;
		
		IF brand_id IS NULL THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Invalid brand';
		END IF;
	END IF;

	IF text <> '' AND NOT text REGEXP '^[0-9a-zA-Z_ ]+$' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid text search';
	END IF;

	SET offs = (page-1)*9;

	SELECT c.*, cat.name FROM cars AS c 
	LEFT JOIN car_category cc ON c.car_id = cc.car_id 
	LEFT JOIN categories cat ON cc.category_id = cat.category_id
	WHERE c.name LIKE CONCAT('%', text, '%')
	AND c.price BETWEEN min_km AND max_km
	AND IF(brand <> '', c.brand = brand_id, 1)
	AND IF(categories <> '', cat.name REGEXP categories_regexp, 1)
	AND c.at >= published
	LIMIT 9 OFFSET offs;
END$$
DELIMITER ;

-- Cars
CALL createCar('Audi', 'Coche audi 1', 2400, 5000, 'Audi');
CALL createCar('Audi A4', 'Coche audi A4', 0, 5000, 'Audi');
CALL createCar('Audi A3', 'Coche audi A3', 2400, 10000, 'Audi');
CALL createCar('Audi Q3', 'Coche audi Q3', 1000, 15000, 'Audi');
CALL createCar('Volvo XC40', 'Coche volvo XC40', 0, 20000, 'Volvo');

CALL searchCar('', 0, 1000000, 'offroad', '', '2020-01-01', 1);
