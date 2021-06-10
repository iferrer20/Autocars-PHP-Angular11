<?php

namespace Utils;

function array_to_obj(array $array, object $obj, bool $prevent_xss = false) { // Simple array to object
    foreach ($array as $key => $value) {
        if (property_exists($obj, $key)) {
            if ($prevent_xss && is_string($value)) {
                $value = htmlentities($value);
            }
            try {
                $obj->{$key} = $value;
            } catch(\TypeError $e) {
                throw new \BadReqException("Invalid " . $key . " value");
            }
        }
    }
}
function remove_file($location) {
    return unlink($location);
}

function is_post() : bool {
    return !empty($_POST);
}
function save_image(string $img_name, string $file_path) {
    $imageFileType = strtolower(pathinfo($file_path,PATHINFO_EXTENSION));
    if ($imageFileType == 'jpg') {
        if (!move_uploaded_file($_FILES[$img_name]['tmp_name'], $file_path)) {
            throw new \Exception('Error saving file');
        }
    }
}
function is_image($filename) {
    if (array_key_exists($filename, $_FILES)) {
        if ($_FILES[$filename]['size'] > 0) {
            return true;
        }
    } 
    return false;
}
function get_method() : string {
    return $_SERVER['REQUEST_METHOD'];
}
function include_folder($folder) {
    if (is_dir($folder)) {
        $files = glob($folder . '/*.php');
        foreach ($files as $file) {
            require_once $file;
        }
    }
}
function get_client_ip() {
    return $_SERVER['REMOTE_ADDR'];
}
function get_cookie($cookie) {
    return $_COOKIE[$cookie];
}
function get_json($file) {
    return json_decode(file_get_contents("jsons/" . $file . ".json"));
}

class res {
    public static bool $replied = false;
    static function redirect($location) {
        header('HTTP/1.1 302 Moved Temporarily');
        header('Location: ' . $location);
    }
    static function notfound($str) {
        http_response_code(404);
        echo json_encode(array(
            "success" => false,
            "error" => $str . " not found"
        ));
        self::$replied = true;
    }
    static function error($str, $code = 400) {
        http_response_code($code);
        echo json_encode(array(
            'success' => false,
            'error' => $str
        ));
        self::$replied = true;
    }
    static function sys_error($exception) {
        http_response_code(500);
        error_log(json_encode($exception), 0);
        echo json_encode(array(
            'success' => false,
            'error' => 'An error ocurred'
        ));
        self::$replied = true;
    }
    static function ok($val = null) {
        if ($val) {
             echo json_encode(array(
                'success' => true,
                'content' => $val
            ));
        } else {
            echo json_encode(array(
                'success' => true
            ));
        }
        self::$replied = true;
    }
}
?>
