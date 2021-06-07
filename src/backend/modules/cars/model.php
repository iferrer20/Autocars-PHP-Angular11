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
    private function get_order_sql($order) {
        switch ($order) {
            default:
            case 'recent':
                $order = 'ORDER BY cars.at DESC';
                break;
            case 'old':
                $order = 'ORDER BY cars.at ASC';
                break;
            case 'expensive':
                $order = 'ORDER BY price DESC';
                break;
            case 'cheap':
                $order = 'ORDER BY price ASC';
                break;
            case 'popular':
                $order = 'ORDER BY views DESC';
                break;
            case 'lesskm':
                $order = 'ORDER BY km ASC';
                break;
            case 'morekm':
                $order = 'ORDER BY km DESC';
                break;
        }
        return $order;
    }
    private function get_category_sql($cat) {
        $categories = "category";
        if (!empty($cat)) {
            $categories = '\'' . join('\', \'', array_map("addslashes", $cat)) . '\'';
        }
        return $categories;
    }
    private function get_published_sql($published) {
        switch ($published) {
            default:
            case 'anytime':
                $published = '\'1990-01-01 00:00:00\'';
                break;
            case 'today':
                $published = 'NOW() - INTERVAL 1 DAY';
                break;
            case 'week':
                $published = 'NOW() - INTERVAL 1 WEEK';
                break;
            case 'month':
                $published = 'NOW() - INTERVAL 1 MONTH';
                break;
            case 'year':
                $published = 'NOW() - INTERVAL 1 YEAR';
                break;
        }
        return $published;
    }

    public function search_car_count(CarSearch $search) {
        return $this->search_car($search, true);
    }
    public function search_car(CarSearch $search, bool $return_count=false) {
        $result = $this->db->query(
            'CALL searchCar(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            'siiiissssii',
            $search->text,
            $search->min_km,
            $search->max_km,
            $search->min_price,
            $search->max_price,
            implode(',', $search->categories),
            $search->brand,
            $search->published,
            $search->sort,
            $search->page,
            $return_count
        );
        if ($return_count) {
            return $result[0]['car_count'];
        } 
        return $result;
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
