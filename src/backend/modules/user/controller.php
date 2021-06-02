<?php 

use Utils\res;
use Utils\Firebase;
use Utils\JWT;

#[requires('middlewares/user.php')] // import middleware
class UserController extends Controller {
    
    public function __construct() {
        parent::__construct();
    }

    private function give_token($uid) {
        setcookie('token', JWT::encode(array('user_id' => $uid)), strtotime('+7 days'), '/', 'localhost', false, true); // http-only security
        setcookie('logged', true, strtotime('+7 days'), '/', 'localhost', false, false); // No http-only
    }
    
    #[utils('jwt')]
    public function signin_post(User $user) {
        $uid = $this->model->signin($user);
        $this->give_token($uid);
    }
    
    #[utils('jwt')]
    public function signup_post(User $user) {
        $uid = $this->model->signup($user);
        $this->give_token($uid);
    }
    
    #[utils('firebase', 'jwt')]
    public function social_signin_post(string $token) {
        $user = Firebase::get_user($token);
        $uid = $this->model->social_signin($user);
        $this->give_token($uid);
    }

    #[middlewares('check_jwt')] // execute middleware before call my_account_get
    public function my_account_get() {
        
    }
    
}


?>
