<?php

use Utils\res;

class CarsController extends Controller {

    // public function list_get() {
    //     res($this->model->get_cars());
    // }
    // public function list_post() {
        
    //     $list = new CarList();
    //     array_to_obj(Client::$data, $list);
    //     $list->validate();

    //     $cars = $this->model->get_cars($list);

    //     $car_count = $this->model->get_car_count();
    //     $pages = $car_count/$list->limit;
    //     $pages += is_float($pages) ? 1 : 0;
    //     $pages = intval($pages);

    //     res(array(
    //         "cars" => $cars,
    //         "pages" => $pages
    //     ));
        
    // }
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
        $pages = $this->model->search_car_count($search, Client::$jwt_data['user_id'])/2;
        $pages += is_float($pages) ? 1 : 0;
        $pages = intval($pages);

        res::ok(array(
            'cars' => $cars,
            'pages' => $pages
        ));
    }
    public function create_post() {
        $car = new Car();
        Utils\array_to_obj($_POST, $car, true);

        $car->validate();
        $id = $this->model->insert_car($car);

        Utils\save_image('img', 'public/img/cars/' . $id . '.jpg');
    }
    public function delete_post(int $id) {
        $car = $this->model->get_car($id);
        if ($car) {
            $this->model->delete_car($car["id"]);
            Utils\remove_file('/var/www/html/img/cars/' . $car["id"] . '.jpg');
        } else {
            Utils\notfound('The car ' . $id);
        }
    }
    public function update_post(Car $car) {
        $this->model->update_car($car);
        if (Utils\is_image('img')) {
            $filepath = 'public/img/cars/' . $car->id . '.jpg';
            Utils\remove_file($filepath);
            Utils\save_image('img', $filepath);
        }
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
