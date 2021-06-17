<?php

use Utils\res;

class CarsController extends Controller {

    public function categories_get() {
        //var_dump($this->model->get_categories());
        Utils\res($this->model->get_categories());
    }
    public function brands_get() {
        Utils\res($this->model->get_brands());
    }
    #[middlewares('check_jwt_optional')]
    public function search_post(CarSearch $search) {
        $cars = $this->model->search_car($search, Client::$jwt_data['user_id']);
        $pages = $this->model->search_car_count($search, Client::$jwt_data['user_id'])/4;
        $pages += is_float($pages) ? 1 : 0;
        $pages = intval($pages);

        res::ok(array(
            'cars' => $cars,
            'pages' => $pages
        ));
    }
    #[middlewares('check_jwt')]
    public function favorite_put(string $car_id) {
        $this->model->set_favorite_car(Client::$jwt_data['user_id'], $car_id);
    }
    #[middlewares('check_jwt')]
    public function favorite_delete(string $car_id) {
        $this->model->unset_favorite_car(Client::$jwt_data['user_id'], $car_id);
    }
    
    /*public function truncate_post() {
        if ($_POST['confirm'] == 'true') {
            $this->model->trucate_cars_table();
        }
    }*/
}

?>
