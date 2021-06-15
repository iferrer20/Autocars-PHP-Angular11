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

export interface User {
    user_id: string,
    username: string,
    email: string,
    expires: number
}

export interface UserSocialSignin {
    token: string
}
