<?php

class ORMType {
    
    private string $type_class;
    private string $insert_columns;
    private string $type_props_types;
    private array $type_props;
    private array $primary_keys;
    private array $type_values;
    
    private Database $db;
    
    public function __construct() {
        $this->type_props = array();
        $this->primary_keys = array();
        $this->type_values = array();
        $this->type_class = get_called_class();
        $reflection_class = new ReflectionClass($this->type_class);
        $props = $reflection_class->getProperties();
        $columns_names = array();
        $columns_values = array();
        $this->type_props_types = '';

        foreach ($props as $prop) {
            $prop_name = $prop->getName();
            if ($prop_name == "table") {
                continue;
            }
            array_push($this->type_props, $prop);
            array_push($columns_names, $prop_name);
            array_push($columns_values, '?');
            $attributes = $prop->getAttributes();
            foreach($attributes as $attribute) {
                $attr_name = $attribute->getName();
                switch ($attr_name) {
                    case 'primary':
                        array_push($this->primary_keys, $prop);
                        break;
                }
            }
            $this->type_values[] = &$this->{$prop_name}; // array push, reference
            switch($prop->getType()->getName()) {
                case 'int':
                    $this->type_props_types .= 'i';
                    break;
                case 'string':
                    $this->type_props_types .= 's';
                    break;
            }
        }
        if (!isset($this->table)) {
            throw new Exception('Please specify table property');
        }
        $this->db = new Database();
        $this->insert_columns = "(" . implode(", ", $columns_names) . ") VALUES (" . implode(", ", $columns_values) . ")";

    }

    public function get(...$values) {
        $query = "SELECT * FROM " . $this->table . " WHERE ";
        $query_attr_types = "";
        $len_count = count($values);
        for ($i=0; $i<$len_count; $i++) {
            $primary_attr = $this->primary_keys[$i]; 
            $value = $values[$i];
            if (!$value) {
                continue;
            }
            $primary_attr_name = $primary_attr->getName();
            $primary_attr_type = $primary_attr->getType()->getName();
            if ($i > 0) {
                $query .= " AND ";
            }
            $query .= $primary_attr_name . " =  ?";
            
            switch($primary_attr_type) {
            case 'int':
                $query_attr_types .= 'i';
                break;
            case 'string':
                $query_attr_types .= 's';
                break;
            }
        }

        $res = $this->db->query($query, $query_attr_types, ...$values)->query->fetch_assoc();
        array_to_obj($res, $this);
    }
    public function update() {

    }
    public function insert() {
        $query = "INSERT INTO " . $this->table . " " . $this->insert_columns;
        $params = array($query, $this->type_props_types);
        $params = array_merge($params, $this->type_values);
        var_dump($params);
        $reflection_method = new ReflectionMethod(get_class($this->db), "query");

        $reflection_method->invokeArgs($this->db, $params);
        //var_dump(call_user_func_array($this->db->query, $params));

        /*$query_str = "INSERT INTO" . $this->table;
        foreach ($type_props as $prop) {
        }
        $this->db->query("INSERT INTO " . $this->table . " ()");*/
    }


}


?>
