<?php

class ErrorController extends Controller {
    public function __construct(Exception $e) {
        parent::__construct(); // Call to parent constructor
        http_response_code(400);
        $this->view->error = $e->getMessage();
        $this->render('index');
    }
}

?>