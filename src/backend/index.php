<?php

header('Access-Control-Allow-Origin: http://localhost:4200');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT');
header('Access-Control-Allow-Headers: X-Requested-With, Content-Type, Origin, Authorization, Accept, Client-Security-Token, Accept-Encoding, X-Auth-Token, content-type');
header('Content-Type: application/json');

// ini_set('display_errors', 1);
// ini_set('display_startup_errors', 1);
// error_reporting(E_ALL);

$folders_to_include = array('mvc_lib', 'utils', 'exceptions');
foreach ($folders_to_include as &$folder) { 
    $files = glob($folder . '/*.php');
    foreach ($files as &$file) {
        include_once $file;
    }
    
}

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    ok();
    exit;
}

$app = new App();

?>
