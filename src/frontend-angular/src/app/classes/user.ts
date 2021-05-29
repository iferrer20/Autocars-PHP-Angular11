export interface UserSignin {
    email: string,
    password: string
}

export interface UserSignup {
    email: string,
    username: string,
    password: string,
    retypePassword: string
}

export interface UserData {
    username: string,
    email: string
}

export interface UserSocialSignin {
    token: string
}
