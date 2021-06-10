<?php

namespace Middlewares;
use Utils;
use Utils\JWT;
use \BadReqException;
use \Client;
use \Exception;

function check_jwt($optional = false) {
    require_once 'utils/jwt.php';
    $token = Utils\get_cookie('token');
    try {
        $jwt_data = (array) JWT::decode($token);
        // Check expiration
        if ($jwt_data->expires >= time()) {
            throw new Exception();
        }
        Client::$jwt_data = $jwt_data;
    } catch(Exception $e) {
        if (!$optional) {
            throw new BadReqException("Invalid token");
        }
    }
}
function check_jwt_optional() {
    check_jwt(true);
}

?>
