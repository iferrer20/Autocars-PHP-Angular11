<?php 

class UserController extends Controller {
    
    public function __construct() {
        parent::__construct();
        require 'lib/php-jwt/src/JWT.php';
    }

    public function signin_post(User $user) {
        $this->model->signin($user);
    }
    public function signup_post(User $user) {
        $this->model->signup($user);
    }
    public function social_signin_post(string $token) {
        $user = Firebase::get_user($token);
        $this->model->social_signin($user);
        
    }

    public function test_post(bool $a) {
        
    }
    
}


?>
