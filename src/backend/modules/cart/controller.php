<?php

use Utils\res;

#[middlewares('check_jwt')] // Check jwt on all actions
class CartController extends Controller {

    public function add_car_put(string $car_id, int $qty) {
        $this->model->add_car(Client::$jwt_data['user_id'], $car_id, $qty);
    }
    public function del_car_delete(string $car_id) {
        $this->model->del_car(Client::$jwt_data['user_id'], $car_id);
    }
    public function get_get() { // Get cart list
        $cart = $this->model->get(Client::$jwt_data['user_id']);
        res::ok($cart);
        
    }
    public function checkout_get() {
        $this->model->checkout(Client::$jwt_data['user_id']);
    }
    
}
?>
