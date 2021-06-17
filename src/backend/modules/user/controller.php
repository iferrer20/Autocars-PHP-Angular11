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
            'expires' => $expires
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
    
    #[utils('jwt', 'mail')]
    public function signup_post(UserSignup $user) {
        $uid = $this->model->signup($user);
        $user = $this->model->get_user($uid);
        // $this->give_access($user);
        $token = base64_encode(JWT::encode([
            "email" => $user->email,
            "expires" => strtotime("+1 hours")
        ]));
        Utils\Mail::send_mail($user->email, "Verify Account", "<h1>Autocars</h1><p>You need to verify account</p><a href=\"http://localhost/verify/$token\"><div style=\"background-color: black; color: white; font-weight: bold; padding: 5px; width: 100px; border-radius: 10px;\">Verificar</div></a>");
        
    }
    #[utils('jwt')]
    public function verify_post(string $token) {
        $token_data = JWT::decode($token); 
        $email = $token_data->email;
        $expiration = $token_data->expires;
        if (time() >= $expiration) {
            throw new BadReqException("Invalid token");
        }
        $this->model->verify_email($email);
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

    #[utils('jwt', 'mail')]
    public function recover_send_post(string $email) {
        if ($this->model->email_exists($email)) {
            $token = base64_encode(JWT::encode([
                "email" => $email,
                "expires" => strtotime("+1 hours")
            ]));
            if ($this->model->email_exists($email)) {
                Utils\Mail::send_mail($email, "Recover password", "<h1>Autocars</h1><p>Recover your password</p><a href=\"http://localhost/recover/$token\"><div style=\"background-color: black; color: white; font-weight: bold; padding: 5px; width: 100px; border-radius: 10px;\">Recover</div></a>");
            }
            
        }
        
    }
    #[utils('jwt')]
    public function recover_changepass_post(string $token, string $new_password) {
        $token_data = JWT::decode($token); 
        $email = $token_data->email;
        $expiration = $token_data->expires;
        if (time() >= $expiration) {
            throw new BadReqException("Invalid token");
        }
        $this->model->change_password($email, $new_password);

    }
}


?>
