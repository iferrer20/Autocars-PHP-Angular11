import { Router } from '@angular/router';
import { ApiConnectorService } from './api-connector.service';
import { UserData, UserSocialSignin, UserSignin, UserSignup } from './../classes/user';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  private logged!: boolean;
  public userData!: UserData | null;

  constructor(private api: ApiConnectorService, private router: Router) {
    let dataJson = localStorage.getItem("user_data");
    this.logged = !!dataJson;
    this.userData = dataJson ? JSON.parse(dataJson) : null;

    if (this.userData && 
      ~~(Date.now()/1000) >= this.userData.expires
    ) { // If expires
      this.logged = false;
      this.userData = null;
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
    console.log(user_data);
    this.logged = true;
    localStorage.setItem("user_data", JSON.stringify(user_data));
    this.router.navigate(['/shop/']);
    
  }

  async signin(userSignin: UserSignin) {
    await this.api.userSignin(userSignin);
  }

  async signup(userSignup: UserSignup) {
    //if (userSignup.email )
    if (userSignup.password != userSignup.retypePassword) {
      throw {field: "retypePassword", str: "mismatchPasswords"};
    }
    
    await this.api.userSignup(userSignup);
  }
  
}
