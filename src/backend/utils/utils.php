<?php

function array_to_obj(array $array, object $obj, bool $prevent_xss = false) { // Simple array to object
    foreach ($array as $key => $value) {
        if (property_exists($obj, $key)) {
            if ($prevent_xss && is_string($value)) {
                $value = htmlentities($value);
            }
            try {
                $obj->{$key} = $value;
            } catch(TypeError $e) {
            }
            
        }
    }
}
function is_post() : bool {
    return !empty($_POST);
}
function save_image(string $img_name, string $file_path) {
    $imageFileType = strtolower(pathinfo($file_path,PATHINFO_EXTENSION));
    if ($imageFileType == 'jpg') {
        if (!move_uploaded_file($_FILES[$img_name]['tmp_name'], $file_path)) {
            throw new Exception('Error saving file');
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
function redirect($location) {
    header('HTTP/1.1 302 Moved Temporarily');
    header('Location: ' . $location);
}
function remove_file($location) {
    return unlink($location);
}
function res($val) {
    http_response_code(200);
    echo json_encode(array(
        "success" => true, 
        "content" => $val
    ));
    global $res;
    $res = true;
}
function notfound($str) {
    http_response_code(404);
    echo json_encode(array(
        "success" => false,
        "error" => $str . " not found"
    ));
    global $res;
    $res = true;
}
function error($str, $code = 400) {
    http_response_code($code);
    echo json_encode(array(
        'success' => false,
        'error' => $str
    ));
    global $res;
    $res = true;
}

function sys_error($str) {
    http_response_code(500);
    var_dump($str);
    $fp = fopen('error.log', 'a');
    fwrite($fp, json_encode($str) . '\n');
    fclose($fp);

    echo json_encode(array(
        'success' => false,
        'error' => 'An error ocurred'
    ));
    global $res;
    $res = true;

}
function ok() {
    echo json_encode(array(
        'success' => true,
    ));
    global $res;
    $res = true;
}
?>
