<?php

class UserModel extends Model {
    public function signin(User $user) {
        $result = $this->db->query(
            'CALL userSignin(?, ?)',
            'ss',
            $user->email,
            $user->password
        );
        return $result[0]['user_id'];
    }
    public function signup(User $user) {
        $result = $this->db->query(
            'CALL userSignup(?, ?, ?)',
            'sss',
            $user->email,
            $user->username,
            $user->password
        );
        return $result[0]['user_id'];
    }
    public function social_signin($user) {
        $result = $this->db->query(
            'CALL userSocialSignin(?)',
            's',
            $user->email
        );
        return $result[0]['user_id'];
    }

}

?>
