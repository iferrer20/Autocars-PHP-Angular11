import { CartService } from './cart.service';
import { Router } from '@angular/router';
import { ApiConnectorService } from './api-connector.service';
import { UserSocialSignin, UserSignin, UserSignup, User } from './../classes/user';
import { Injectable, SimpleChanges } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  private logged!: boolean;
  public user!: User | null;

  constructor(private api: ApiConnectorService, 
              private router: Router) {
    let dataJson = localStorage.getItem("user");
    this.logged = !!dataJson;
    this.user = dataJson ? JSON.parse(dataJson) : null;

    if (this.user && 
      ~~(Date.now()/1000) >= this.user.expires
    ) { // If expires
      this.logged = false;
      this.user = null;
    }
  }
  public isLogged() {
    return this.logged;
  }
  public setLogged(value: boolean) {
    this.logged = value;
  }

  async socialSignin(social: UserSocialSignin) {
    let user_data = await this.api.userSocialSignin(social);
    this.logged = true;
    this.user = user_data;
    localStorage.setItem("user", JSON.stringify(user_data));
  
    this.router.navigate(['/shop/']);
  }

  async signin(userSignin: UserSignin) {
    this.user = await this.api.userSignin(userSignin);
    this.logged = true;
    this.router.navigate(['/shop/']);
  }

  async signup(userSignup: UserSignup) {
    //if (userSignup.email )
    if (userSignup.password != userSignup.retypePassword) {
      throw {field: "retypePassword", str: "mismatchPasswords"};
    }
    
    await this.api.userSignup(userSignup);
  }

  async logout() {
    await this.api.userLogout();
    localStorage.removeItem("user") // Remove user from local storage
    this.logged = false;
    this.user = null;
    this.router.navigate(['/signin/']);
  }
  
}
