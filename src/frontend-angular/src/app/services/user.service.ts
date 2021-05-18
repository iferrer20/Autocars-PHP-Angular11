import { UserData } from '../classes/userdata';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  private logged: boolean;
  public userData!: UserData;

  constructor() {
    let dataJson = localStorage.getItem("user_data");
    this.logged = !!dataJson;
    this.userData = dataJson ? JSON.parse(dataJson) : null;
  }
  public isLogged() {
    return this.logged;
  }
}
