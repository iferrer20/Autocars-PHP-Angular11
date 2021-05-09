<?php

class CarsModel extends Model {
    // CREATE
    public function insert_car(Car $car) : int {
        //$query = $this->db->conn->prepare("INSERT INTO cars (name, description, price) VALUES (?, ?, ?)");
        // $query->bind_param('sss', $name, $description, $price);
        // $query->execute();
        // $result = $query->get_result();
        // return $result;
        $result = $this->db->query(
            'INSERT INTO cars (name, price, description) VALUES (?, ?, ?)', 
            'sss',
            $car->name, $car->price, $car->description
        );
        return $result->insert_id;
    
    }
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
        $result = $result->query->fetch_all(MYSQLI_NUM);
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
        
        return $result->query->fetch_all(MYSQLI_ASSOC)[0];
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
    public function search_car(CarSearch $search) {
        $categories = $this->get_category_sql($search->categories);
        $order = $this->get_order_sql($search->order);
        $published = $this->get_published_sql($search->published);

        $result = $this->db->query(
            "SELECT cars.id, description, cars.name, b.brand, km, price, at, cat.category FROM cars LEFT JOIN brands b ON b.id = cars.id LEFT JOIN car_category cc ON cars.id = cc.car_id LEFT JOIN categories cat ON cc.category_id = cat.id WHERE category IN ($categories) AND price BETWEEN ? AND ? AND km BETWEEN ? AND ? AND b.brand LIKE ? AND (cars.name LIKE CONCAT('%', ?, '%') OR cars.description LIKE CONCAT('%', ?, '%')) AND at >= $published $order",
            'iiiisss',
            $search->min_price, $search->max_price,
            $search->min_km, $search->max_km,
            $search->brand,
            $search->text, $search->text,
        );

        //$search->limit, ($search->page-1)*$search->limit
        $result = $result->query->fetch_all(MYSQLI_ASSOC);
        $count = count($result);
        $result_arr = array();
        
        for ($i=(($search->page-1)*$search->limit);$i<$count;$i++) {
            if ($i >= ((($search->page-1)*$search->limit) + ($search->limit))) {
                break;
            }
            
            $row = $result[$i];
            array_push($result_arr, $row);
        }
        return $result_arr;

        // $categories = $this->get_category_sql($search->categories);
        // $order = $this->get_order_sql($search->order);
        // $published = $this->get_published_sql($search->published);

        // $result = $this->db->query(
        //     "SELECT cars.id, description, cars.name, b.brand, km, price, at, cat.category FROM cars LEFT JOIN brands b ON b.id = cars.id LEFT JOIN car_category cc ON cars.id = cc.car_id LEFT JOIN categories cat ON cc.category_id = cat.id WHERE category IN ($categories) AND price BETWEEN ? AND ? AND km BETWEEN ? AND ? AND b.brand LIKE ? AND (cars.name LIKE CONCAT('%', ?, '%') OR cars.description LIKE CONCAT('%', ?, '%')) AND at >= $published $order LIMIT ? OFFSET ?",
        //     'iiiisssii',
        //     $search->min_price, $search->max_price,
        //     $search->min_km, $search->max_km,
        //     $search->brand,
        //     $search->text, $search->text,
        //     $search->limit, ($search->page-1)*$search->limit
        // );

        // return $result->query->fetch_all(MYSQLI_ASSOC);
    }
    
    public function search_car_count(CarSearch $search) {
        $categories = $this->get_category_sql($search->categories);
        $published = $this->get_published_sql($search->published);
        $result = $this->db->query(
            "SELECT COUNT(cars.id) as car_count FROM cars LEFT JOIN brands b ON b.id = cars.id LEFT JOIN car_category cc ON cars.id = cc.car_id LEFT JOIN categories cat ON cc.category_id = cat.id WHERE category IN ($categories) AND price BETWEEN ? AND ? AND km BETWEEN ? AND ? AND at > '1990-01-01 00:00:00' AND b.brand LIKE ? AND (cars.name LIKE CONCAT('%', ?, '%') OR cars.description LIKE CONCAT('%', ?, '%')) AND at >= $published",
            'iiiisss',
            $search->min_price, $search->max_price,
            $search->min_km, $search->max_km,
            $search->brand,
            $search->text, $search->text
        );

        return $result->query->fetch_all(MYSQLI_ASSOC)[0]["car_count"];
    }
    public function get_categories() {
        $result = $this->db->query(
            "SELECT category FROM categories"
        );
        $result = $result->query->fetch_all(MYSQLI_NUM);
        $ncat = count($result);
        $categories = array();
        for ($i=0;$i<$ncat; $i++) {
            array_push($categories, $result[$i][0]);
        }

        return $categories;
    }

    // UPDATE
    public function update_car(Car $car) {
        $result = $this->db->query(
            'UPDATE cars SET name=?, description=?, price=?, km=?, at=? WHERE id=?',
            'ssiisi',
            $car->name, $car->description, $car->price, $car->km, $car->at, $car->id
        );
    }
    // DELETE
    public function delete_car(int $id) {
        $this->db->query(
            'DELETE FROM cars WHERE id=?',
            'i',
            $id
        );
    }
    public function trucate_cars_table() {
        $this->db->query('TRUNCATE TABLE cars');
    }

    // OTHER
    public function get_car_count() : int {
        $result = $this->db->query('SELECT COUNT(*) total_cars FROM cars')->query->fetch_assoc()['total_cars'];
        return intval($result);
    }
}


?>
