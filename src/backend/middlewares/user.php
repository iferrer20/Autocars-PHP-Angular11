<?php

namespace Middlewares;
use Utils;
use Utils\JWT;
use \BadReqException;
use \Client;
use \Exception;

function check_jwt() {
    require_once 'utils/jwt.php';
    $token = Utils\get_cookie('token');
    try {
        Client::$jwt_data = (object) JWT::decode($token);
        // Check expiration
        if (Client::$jwt_data->expires >= time()) {
            throw new BadReqException("Invalid token");
        }
    } catch(Exception $e) {
        throw new BadReqException("Invalid token");
    }
}

?>
