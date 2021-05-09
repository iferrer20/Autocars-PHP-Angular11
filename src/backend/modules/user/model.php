<?php

class UserModel extends Model {
    public function insert_user(User $user) : void {
        $result = $this->db->query(
            'INSERT INTO users (email, password, firstName, lastName, birthday, gender) VALUES (?, ?, ?, ?, ?, ?)',
            'sssssi',
            $user->email,
            $user->password,
            $user->firstname,
            $user->lastname,
            $user->birthday,
            $user->gender
        ); 
        $user->id = $result->insert_id;
    }
    public function signin(User $user) {
        $result = $this->db->query(
            'CALL userSignin(?, ?)',
            'ss',
            $user->email,
            $user->password
        );
    }
    public function signup(User $user) {
        $result = $this->db->query(
            'CALL userSignup(?, ?, ?)',
            'sss',
            $user->email,
            $user->username,
            $user->password
        );
    }
    public function get_user(User $user) {
        $result = $this->db->query(
            'SELECT * FROM users WHERE email=? OR user_id=?',
            'si',
            $user->email, 
            $user->user_id
        );
        $user_array = $result->query->fetch_assoc();
        if ($user_array) {
            $real_user = new User();
            array_to_obj($real_user, $user_array);
            return $real_user;
        }
        return null;
    }

}

?>
