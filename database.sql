CREATE DATABASE autocars;
USE autocars;

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
	name VARCHAR(20) NOT NULL,
	description VARCHAR(1000) NOT NULL,
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
	privileges ENUM('ADMIN', 'STAFF'),
	verified BOOLEAN DEFAULT 0
);

DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites (
	user_id CHAR(17) NOT NULL,
	car_id CHAR(17) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
	FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE,
	PRIMARY KEY (user_id, car_id)
);

DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
	user_id CHAR(17) NOT NULL,
	car_id CHAR(17) NOT NULL,
	qty INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
	FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE,
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

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS createHash;
DELIMITER $$
CREATE FUNCTION createHash(password VARCHAR(100)) RETURNS CHAR(44)
BEGIN
	DECLARE salt CHAR(4);
	DECLARE hash CHAR(40);
	
	SET salt = SUBSTRING(MD5(RAND()) from 1 for 4);
	SET hash = SHA1(CONCAT(salt, password));

	RETURN CONCAT(salt, hash);
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
	DECLARE errstr VARCHAR(255);
	DECLARE err VARCHAR(255);
	DECLARE EXIT HANDLER FOR 1062
	BEGIN
		GET DIAGNOSTICS CONDITION 1 err = MESSAGE_TEXT;
		SET err = REPLACE(SUBSTRING_INDEX(err, '\'', -2), '\'', '');
		CASE err
			WHEN 'users.email' THEN SET errstr = 'Email already in use';
			WHEN 'users.username' THEN SET errstr = 'Username already in use';
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

	
	SET user_id = UUID_SHORT();
	
	INSERT INTO users (user_id, email, username, password) VALUES (user_id, email, username, createHash(password));
	SELECT user_id;
END$$
DELIMITER ;





/* DROP PROCEDURE IF EXISTS userSetPrivilege;
CREATE PROCEDURE userSetPrivilege (
	IN user_id CHAR(17)
)
BEGIN
*/
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
		DECLARE verified BOOLEAN;
		
		SELECT SUBSTRING(u.password, 1, 4), SUBSTRING(u.password, 5), u.user_id, u.verified
		INTO salt, realhash, user_id, verified
		FROM users AS u 
		WHERE (u.username = username OR u.email = username) 
		LIMIT 1;

		IF NOT verified THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'You must verify email';
		END IF;

		IF realhash IS NOT NULL THEN
			SET hash = SHA1(CONCAT(salt, password));
			IF NOT STRCMP(hash, realhash) THEN
				LEAVE checkHash;
			END IF;
		ELSEIF user_id IS NOT NULL THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'You must login with gmail or github';
		END IF;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid username or password';
	END;
	SELECT user_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS userChangePassword;
DELIMITER $$
CREATE PROCEDURE userChangePassword(
	IN user_id VARCHAR(100),
	IN password VARCHAR(100)
)
BEGIN
	/* VALIDATION */
	IF LENGTH(password) < 5 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Password too short';
	END IF;

	UPDATE users AS u SET u.password=createHash(password) WHERE u.user_id = user_id OR u.email = user_id LIMIT 1;
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
		INSERT INTO users (user_id, email, username, password, verified) VALUES (user_id, email, NULL, NULL, 1);
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
	IN min_price INT,
	IN max_price INT,
	IN categories VARCHAR(128),
	IN brand VARCHAR(20),
	IN published VARCHAR(20),
	IN sort VARCHAR(20),
	IN user_id CHAR(17),
	IN page INT,
	IN _limit INT
)
BEGIN
	DECLARE brand_id INT;
	DECLARE _offset INT;
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

	SET _offset = (page-1)*_limit;

	IF page < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid page';
	END IF;

	CREATE TEMPORARY TABLE car_search_result AS SELECT c.*, f.car_id IS NOT NULL AS favorite FROM cars AS c 
	LEFT JOIN car_category cc ON c.car_id = cc.car_id 
	LEFT JOIN categories cat ON cc.category_id = cat.category_id
	LEFT JOIN favorites f ON user_id <> '' AND c.car_id = f.car_id AND user_id = f.user_id
	WHERE c.name LIKE CONCAT('%', text, '%')
	AND c.km BETWEEN min_km AND max_km
	AND c.price BETWEEN min_price AND max_price
	AND IF(brand <> '', c.brand = brand_id, 1)
	AND IF(categories <> '', cat.name REGEXP categories_regexp, 1)
	AND 
	CASE published
		WHEN 'today' THEN c.at >= NOW() - INTERVAL 1 DAY
		WHEN 'week'  THEN c.at >= NOW() - INTERVAL 1 WEEK
		WHEN 'month' THEN c.at >= NOW() - INTERVAL 1 MONTH
		WHEN 'year'  THEN c.at >= NOW() - INTERVAL 1 YEAR
		WHEN ''      THEN 1
	END 
	GROUP BY c.car_id;

	IF page > 0 THEN
		SELECT * FROM car_search_result AS c
		ORDER BY 
			CASE sort WHEN 'oldest'  THEN c.at END ASC,
			CASE sort WHEN 'cheaper' THEN c.price END ASC,
			CASE sort WHEN 'leastkm' THEN c.km END ASC, 

			CASE sort WHEN 'recent'     THEN c.at END DESC,
			CASE sort WHEN 'expensive'  THEN c.price END DESC,
			CASE sort WHEN 'mostkm'     THEN c.km END DESC,
			CASE sort WHEN 'popularity' THEN c.views END DESC
		LIMIT _limit OFFSET _offset;
	ELSE
		SELECT COUNT(*) AS car_count FROM car_search_result;
	END IF;

	DROP TABLE car_search_result;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS setFavoriteCar;
DELIMITER $$
CREATE PROCEDURE setFavoriteCar(
	IN user_id CHAR(17),
	IN car_id CHAR(17)
)
BEGIN
	DECLARE EXIT HANDLER FOR 1062
	BEGIN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Car already is in favorites';
	END;
	DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Car do not exists';
	END;
	INSERT INTO favorites VALUES (user_id, car_id);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS unsetFavoriteCar;
DELIMITER $$
CREATE PROCEDURE unsetFavoriteCar(
	IN user_id CHAR(17),
	IN car_id CHAR(17)
)
BEGIN
	DELETE FROM favorites AS f WHERE f.user_id = user_id AND f.car_id = car_id;
	
	IF ROW_COUNT() = 0 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Car is not in favorites';
	END IF;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS getCart;
DELIMITER $$
CREATE PROCEDURE getCart(
	IN user_id CHAR(17)
)
BEGIN
	SELECT * FROM cart AS c WHERE c.user_id = user_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS addToCart;
DELIMITER $$
CREATE PROCEDURE addToCart(
	IN user_id CHAR(17),
	IN car_id CHAR(17),
	IN qty INT
)
BEGIN
	DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Car do not exists';
	END;

	IF qty < 1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid quantity';
	END IF;

	IF NOT EXISTS(SELECT car_id FROM cart AS c WHERE c.user_id = user_id AND c.car_id = car_id) THEN
		INSERT INTO cart VALUES (user_id, car_id, qty);
	ELSE
		UPDATE cart AS c SET c.qty = qty WHERE c.user_id = user_id AND c.car_id = car_id LIMIT 1;
	END IF;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS delFromCart;
DELIMITER $$
CREATE PROCEDURE delFromCart(
	IN user_id CHAR(17),
	IN car_id CHAR(17)
)
BEGIN
	DELETE FROM cart AS c WHERE c.user_id = user_id AND c.car_id = car_id LIMIT 1;
	IF ROW_COUNT() = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The car is not in cart';
	END IF;
	
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS delFromCart;
DELIMITER $$
CREATE PROCEDURE delFromCart(
	IN user_id CHAR(17),
	IN car_id CHAR(17)
)
BEGIN
	DELETE FROM cart AS c WHERE c.user_id = user_id AND c.car_id = car_id LIMIT 1;
	IF ROW_COUNT() = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The car is not in cart';
	END IF;
	
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS getCart;
DELIMITER $$
CREATE PROCEDURE getCart(
	IN user_id CHAR(17)
)
BEGIN
	SELECT cars.*, c.qty FROM cart AS c INNER JOIN cars ON cars.car_id = c.car_id WHERE c.user_id = user_id;
END$$
DELIMITER ;


-- Cars
CALL createCar('Audi', 'Coche audi 1', 2400, 5000, 'Audi');
CALL createCar('Audi A4', 'Coche audi A4', 0, 5000, 'Audi');
CALL createCar('Audi A3', 'Coche audi A3', 2400, 10000, 'Audi');
CALL createCar('Audi Q3', 'Coche audi Q3', 1000, 15000, 'Audi');
CALL createCar('Volvo XC40', 'Coche volvo XC40', 0, 20000, 'Volvo');

CALL searchCar('', 0, 1000000, 0, 1000000, '', '', '', 'expensive', '', 1, 2);
