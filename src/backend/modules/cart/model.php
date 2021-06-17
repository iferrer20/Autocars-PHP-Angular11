<?php

class CartModel extends Model {

    public function add_car($user_id, $car_id, $qty) {
        $this->db->query(
            'CALL addToCart(?, ?, ?)',
            'ssi',
            $user_id,
            $car_id,
            $qty
        );
    }
    public function del_car($user_id, $car_id) {
        $this->db->query(
            'CALL delFromCart(?, ?)',
            'ss',
            $user_id,
            $car_id
        );
    }
    public function get($user_id) {
        return $this->db->query(
            'CALL getCart(?)',
            's',
            $user_id
        );
    }
    public function checkout($user_id) {
        return $this->db->query(
            'CALL cartCheckout(?)',
            's',
            $user_id
        );
    }
    
}


?>
