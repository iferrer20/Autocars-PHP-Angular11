


-- TABLA
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  email varchar(64) NOT NULL UNIQUE,
  username varchar(20) NOT NULL UNIQUE,
  password char(45) 
);

-- Procedures
DROP PROCEDURE IF EXISTS userSignup;
DELIMITER $$
CREATE PROCEDURE userSignup (
	IN email VARCHAR(64), 
	IN username VARCHAR(20), 
	IN password VARCHAR(64)
)
BEGIN
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
	INSERT INTO users (email, username, password) VALUES (email, username, CONCAT(salt, '.', hash));
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS userSignin;
DELIMITER $$
CREATE PROCEDURE userSignin (
	IN username VARCHAR(20), 
	IN password VARCHAR(64)
) 
BEGIN
	checkHash:BEGIN
		DECLARE hash CHAR(40);
		DECLARE realhash CHAR(40);
		DECLARE salt CHAR(4);
		
		SELECT SUBSTRING_INDEX(u.password, '.', 1), SUBSTRING_INDEX(u.password, '.', -1) 
		INTO salt, realhash 
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
END$$
DELIMITER ;

