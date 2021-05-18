import { Injectable } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/auth';
import firebase from 'firebase/app';

@Injectable({
  providedIn: 'root'
})
export class AuthServiceService {

  private logged: boolean = localStorage.getItem('logged') == "1" ? true : false;

  constructor(private auth: AngularFireAuth) {

  }

  public async googleAuth() {
    let user = await this.auth.signInWithPopup(new firebase.auth.GoogleAuthProvider);
    console.log(user);
  }

  public async twitterAuth() {
    let user = await this.auth.signInWithPopup(new firebase.auth.TwitterAuthProvider);
    console.log(user);
  }
  public async githubAuth() {
    let user = await this.auth.signInWithPopup(new firebase.auth.GithubAuthProvider);
    console.log(user);
  }

  public isLogged() {
    return this.logged;
  }
  
}
