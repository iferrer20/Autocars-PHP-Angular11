<?php 

use Utils\res;
use Utils\Firebase;
use Utils\JWT;

class UserController extends Controller {
    
    public function __construct() {
        parent::__construct();
    }

    private function give_access($user) {
        $expires = strtotime("+1 week");
        $token = JWT::encode([
            'user_id' => $user->user_id,
            'expires' => strtotime($expires)
        ]);
        setcookie('token', $token, $expires, '/', 'localhost', false, true); // http-only security
        // Give aditional user data
        res::ok([
                "user_id" => $user->user_id,
                "username" => $user->username,
                "email" => $user->email,
                "expires" => $expires
            ]
        ); 
        
    }
    
    #[utils('jwt')]
    public function signin_post(UserSignin $user) {
        $uid = $this->model->signin($user);
        $user = $this->model->get_user($uid);
        $this->give_access($user);
    }
    
    #[utils('jwt')]
    public function signup_post(UserSignup $user) {
        $uid = $this->model->signup($user);
        $user = $this->model->get_user($uid);
        $this->give_access($user);
    }
    
    #[utils('firebase', 'jwt')]
    public function social_signin_post(string $token) {
        $firebase_user = Firebase::get_user($token);
        $uid = $this->model->social_signin($firebase_user);
        $user = $this->model->get_user($uid);
        $this->give_access($user);
    }

    #[middlewares('check_jwt')] // execute middleware before call my_account_get
    public function my_profile_get() {
        $user = $this->model->get_user(Client::$jwt_data['user_id']);
        res::ok([
            'username' => $user->username,
            'email' => $user->email
        ]);
    }
    #[middlewares('check_jwt')]
    public function logout_get() {
        setcookie('token', "", time() - 3600, '/', 'localhost', false, true); // Remove token
    }
    
}


?>
