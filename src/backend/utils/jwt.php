<?php

namespace Utils;

require_once 'lib/php-jwt/src/BeforeValidException.php';
require_once 'lib/php-jwt/src/ExpiredException.php';
require_once 'lib/php-jwt/src/SignatureInvalidException.php';
require_once 'lib/php-jwt/src/JWT.php';

use \Firebase\JWT\JWT as _JWT;

class JWT {
    public static $password;
    public static function encode(array $arr) {
        return _JWT::encode($arr, self::$password);
    }
    public static function decode($token) {
        return _JWT::decode($token, self::$password, array('HS256'));
    }
    public static function set_password($password) {
        self::$password = $password;
        
    }
}

JWT::set_password(\Misc\get_json("jwt")->password);

?>
