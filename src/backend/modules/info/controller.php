<?php

class InfoController extends Controller {
    public string $default = 'main';

    public function __construct() {
        parent::__construct();
    }

    public function main_get() {
        $this->render('info');
    }
}


?>