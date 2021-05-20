<?php

class App {

    public function __construct() {
        global $res;

        // uri = /api/cars/search -> ['cars','search_post']
        $uri = htmlentities(str_replace("/api/", "", $_GET['uri'])); // Prevent xss
        $uri = explode('/', rtrim($uri, '/'));  // Split uri 

        $this->uri = $uri;

        $controller_name = $uri[0] ?? '';
        $action_name = $uri[1] ?? '';

        if ($controller = $this->load_controller($controller_name)) {
            if ($action_func = $this->load_action($controller, $action_name)) {
                try {
                    $this->call_middlewares($controller, $action_func);
                    $this->call_action($controller, $action_func);
                    if (!$res) {
                        ok();
                    }
                } catch(BadReqException $e) {
                    error($e->getMessage());
                } catch(Exception $e) {
                    sys_error($e);
                }
            } else {
                notfound($action_name);
            }
        } else {
            notfound($controller_name);
        }
    } 

    private function load_controller($module_name) {
        $file_controller = 'modules/' . $module_name . '/controller.php';
        if (file_exists($file_controller)) { 
                require_once $file_controller;
            $class_cl_name = $module_name . 'Controller';
            $controller = new $class_cl_name;
            return $controller;
        } 
    }

    private function load_action($controller, $action_name) {
        $function_name = $action_name . '_' . strtolower(get_method());
        if (method_exists($controller, $function_name)) {
            return $function_name;
        } 
    }

    private function call_action($controller, $func) {
        $reflection_method = new ReflectionMethod(get_class($controller), $func);
        $reflection_params = $reflection_method->getParameters();
        
        $params = array();
        $r_param_count = count($reflection_params);

        foreach ($reflection_params as $param) { // get parameters of action
            $param_name = $param->getName();
            $param_class = $param->getType()->getName();
            if (class_exists($param_class)) {
                $obj = new $param_class();
                array_to_obj($r_param_count > 1 ? Client::$data[$param_name] : Client::$data, $obj, true);
                
                $type_reflection = new ReflectionClass(get_class($obj));
                $props = $type_reflection->getProperties(ReflectionProperty::IS_PUBLIC);
                foreach($props as $prop) {
                    if (!isset($obj->{$prop->getName()})) {
                        throw new BadReqException("You need to specify " . $prop->getName() . " value");
                    }
                }

                if (method_exists($obj, "validate")) {
                    $obj->validate();
                }
            } else {
                $obj = Client::$data[$param_name];
            }

            array_push($params, $obj);
        }
        $reflection_method->invokeArgs($controller, $params); // Call action
        //$controller->{$func}();
    }

    private function call_middlewares($controller, $func) {
        $reflection_class = new ReflectionClass(get_class($controller));
        $reflection_method = new ReflectionMethod(get_class($controller), $func);
        $attributes = array_merge(
            $reflection_method->getAttributes(), 
            $reflection_class->getAttributes()
        );
        $params = $reflection_method->getParameters();

        // Call default middleware
        Middlewares::default($controller);

        // Call to middlewares
        foreach ($attributes as $attribute) {
            switch ($attribute->getName()) {
                case 'middlewares':
                    foreach ($attribute->getArguments() as $argument) {
                        if (method_exists('Middlewares', $argument)) {
                            Middlewares::{$argument}();
                        }
                    }
                    break;
            }
        }
    }
}
?>
