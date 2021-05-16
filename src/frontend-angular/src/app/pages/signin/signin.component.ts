import { Component, OnInit } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/auth';
import firebase from 'firebase/app';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.css']
})
export class SigninComponent implements OnInit {

  constructor(private auth: AngularFireAuth) {

  }

  ngOnInit(): void {
  }

  async loginWithGoogle() {
    let user = await this.auth.signInWithPopup(new firebase.auth.GoogleAuthProvider);
    console.log(user);
  }

}
