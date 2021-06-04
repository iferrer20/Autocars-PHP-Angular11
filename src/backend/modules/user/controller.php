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
        $expires = "+1 week";
        $token = JWT::encode([
            'user_id' => $uid,
            'expires' => strtotime($expires)
        ]);
        setcookie('token', $token, strtotime($expires), '/', 'localhost', false, true); // http-only security
        setcookie('logged', true, strtotime($expires), '/', 'localhost', false, false); // No http-only
    }
    
    #[utils('jwt')]
    public function signin_post(UserSignin $user) {
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
    public function my_profile_get() {
        $user = $this->model->get_user(Client::$jwt_data->user_id);
        res::ok([
            'username' => $user->username,
            'email' => $user->email
        ]);
        
    }
    
}


?>
