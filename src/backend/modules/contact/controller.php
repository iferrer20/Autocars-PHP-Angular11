<?php

class ContactController extends Controller {
    public string $default = 'contact';

    public function __construct() {
        parent::__construct();
    }

    public function contact_get() {
        $this->render('contact');
    }
}



?>