<?php

class NotFoundController extends Controller {
    public function __construct($str) {
        parent::__construct(); // Call to parent constructor
        http_response_code(404);
        $this->view->data = $str;
        $this->render('index');
        exit();
    }
}

?>