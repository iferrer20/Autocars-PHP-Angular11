<?php
    $name = $_POST['name'];
    $desc = $_POST['desc'];
    $price = $_POST['price'];

    if ($name && $desc && $price) {
        if (strlen($name) > 0) {

        }
    } else {
        throw new Exception(array("create", "Invalid arguments"));
    }

?>