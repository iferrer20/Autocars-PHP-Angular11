<?php

namespace Misc;

function get_json($file) {
    return json_decode(file_get_contents("misc/jsons/" . $file . ".json"));
}


?>
