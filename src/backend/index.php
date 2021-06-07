<?php

header('Access-Control-Allow-Origin: http://localhost:4200');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT');
header('Access-Control-Allow-Headers: X-Requested-With, Content-Type, Origin, Authorization, Accept, Client-Security-Token, Accept-Encoding, X-Auth-Token, content-type');
header('Content-Type: application/json');

/* 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
*/

require 'utils/utils.php';
$folders_to_include = array('mvc_lib', 'exceptions');

foreach ($folders_to_include as $folder) { 
    Utils\include_folder($folder);
}



require 'middlewares/middlewares.php';

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    Utils\res::ok();
    exit();
}

$app = new App();

?>
