<?php 

class UserController extends Controller {
    public function signin_post(User $user) {
        $this->model->signin($user);
    }
    public function signup_post(User $user) {
        $this->model->signup($user);
    }
    /*
        
    */

    public function signin_social_post(SocialUser $social_user) {
        var_dump($social_user);
    }
    public function list_get() {

    }
    
}


?>
