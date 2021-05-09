<?php

class View {
    public $data;
    public string $module;
    public string $header = 'header/view';
    public string $footer = 'footer/view';

    public function __construct(string $module) {
        $this->module = $module;
    }
    public function render(string $name) {
        require 'modules/' . $this->module . '/views/' . $name . '.php';
    }
    public function renderAll(string $name) {
        require 'modules/' . $this->header . '.php';
        require 'modules/' . $this->module . '/views/' . $name . '.php';
        require 'modules/' . $this->footer . '.php';
    }

    public function get_title() : string {
        global $uri;
        if (isset($this->title)) {
            return $this->title;
        } else {
            return $uri[1];
        }
    }
}

?>