<?php

abstract class Controller {
    public string $module_name;
    public $model; // No type (herency)
    public $uri;

    public function __construct() {
        global $uri;
        $this->uri = $uri;
        $this->module_name = strtolower(str_replace('Controller', '', get_called_class()));
        $this->load_types();
        $this->load_model();
    }

    public function load_model() {
        $file_model = 'modules/' . $this->module_name . '/model.php';
        $model_name = $this->module_name . 'model';
        
        if (file_exists($file_model)) {
            include $file_model;
            if (class_exists($model_name)) {
                $this->model = new $model_name;
            }
        }
    }
    
    public function load_types() {
        $type_folder = 'modules/' . $this->module_name . '/types/';
        if (is_dir($type_folder)) {
            $files = glob($type_folder . '*.php');
            foreach ($files as $filename) {
                include $filename;
            }
        }
    }

    public function action_notfound() {
        new NotFoundController('action ' . $this->uri[2]);
    }
    public function notfound($str) {
        new NotFoundController($str);
    }
    public function render(string $name) {
        $this->view->renderAll($name);
    }
    public function end() {
        $this->model->db->close();
    }
}

?>
