<?php

class CarsModel extends Model {
    // CREATE
    // public function insert_car(Car $car) : int {
        //$query = $this->db->conn->prepare("INSERT INTO cars (name, description, price) VALUES (?, ?, ?)");
        // $query->bind_param('sss', $name, $description, $price);
        // $query->execute();
        // $result = $query->get_result();
        // return $result;
        // $result = $this->db->query(
        //    'INSERT INTO cars (name, price, description) VALUES (?, ?, ?)', 
        //    'sss',
        //    $car->name, $car->price, $car->description
        // );
        // return $result->insert_id;
    
    // }
    // READ
    // public function get_cars(CarList $list_params) : array {
    //     $result = $this->db->query(
    //         'SELECT * FROM cars ORDER BY id DESC LIMIT ? OFFSET ?',
    //         'ii',
    //         $list_params->limit, ($list_params->page-1)*$list_params->limit
    //     );
    //     // $cars = array();
    //     // while ($row = $result->query->fetch_assoc()) {
    //     //     $car = new Car();
    //     //     array_to_obj($row, $car);
    //     //     array_push($cars, $car);
    //     // }

    //     return $result->query->fetch_all(MYSQLI_ASSOC);
    // }
    public function get_brands() {
        $result = $this->db->query(
            "SELECT brand FROM brands"
        );
        $nbrands = count($result);
        $brands = array();
        for ($i=0;$i<$nbrands; $i++) {
            array_push($brands, $result[$i][0]);
        }

        return $brands;
    }
    public function get_car(int $id) {
        $this->db->query( // views
            'UPDATE cars SET views=views+1 WHERE id=?',
            'i',
            $id
        );

        $result = $this->db->query(
            'SELECT cars.id, description, cars.name, b.brand, km, price, at, cat.category FROM cars LEFT JOIN brands b ON b.id = cars.id LEFT JOIN car_category cc ON cars.id = cc.car_id LEFT JOIN categories cat ON cc.category_id = cat.id WHERE cars.id = ?',
            'i',
            $id
        );
        
        return $result;
    } 
    public function search_car_count(CarSearch $search, string $user_id) {
        return $this->search_car($search, $user_id, true);
    }
    public function search_car(CarSearch $search, string $user_id, bool $return_count=false) {
        $result = $this->db->query(
            'CALL searchCar(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            'siiiisssssii',
            $search->text,
            $search->min_km,
            $search->max_km,
            $search->min_price,
            $search->max_price,
            implode(',', $search->categories),
            $search->brand,
            $search->published,
            $search->sort,
            $user_id,
            $return_count ? 0 : $search->page,
            4
        );
        if ($return_count) {
            return $result[0]['car_count'];
        } 
        return $result;
    }

    public function set_favorite_car(string $user_id, string $car_id) {
        $this->db->query(
            'CALL setFavoriteCar(?, ?)',
            'ss',
            $user_id,
            $car_id
        );
    }
    public function unset_favorite_car(string $user_id, string $car_id) {
        $this->db->query(
            'CALL unsetFavoriteCar(?, ?)',
            'ss',
            $user_id,
            $car_id
        );
    }

    public function trucate_cars_table() {
        $this->db->query('TRUNCATE TABLE cars');
    }
    // OTHER
    public function get_car_count() : int {
        $result = $this->db->query('SELECT COUNT(*) total_cars FROM cars')['total_cars'];
        return intval($result);
    }
}


?>
