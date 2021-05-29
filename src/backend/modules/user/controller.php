<?php 

class UserController extends Controller {
    
    public function __construct() {
        parent::__construct();
        
    }

    public function signin_post(User $user) {
        $this->model->signin($user);
    }
    public function signup_post(User $user) {
        $this->model->signup($user);
        res(array("token" => jwt_encode(array("test" => 1), "test")));
    }

    public function social_signin_post(string $token) {
        $user = Firebase::get_user($token);
        $this->model->social_signin($user);
    }
    
}


?>
