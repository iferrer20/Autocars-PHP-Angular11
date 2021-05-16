import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthServiceService {

  private logged: boolean = !!localStorage.getItem('logged');

  constructor() {}

  public isLogged() {
    return this.logged;
  }
  
}
