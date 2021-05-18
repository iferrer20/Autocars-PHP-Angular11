import { SocialLogin } from './../../classes/socialLogin';
// import { firebase } from 'firebase/app';
import { ApiConnectorService } from './../../services/api-connector.service';
import { Component, OnInit } from '@angular/core';
import { UserService } from 'src/app/services/user.service';
import { FirebaseuiAngularLibraryService, FirebaseUIModule, FirebaseUISignInSuccessWithAuthResult, NativeFirebaseUIAuthConfig } from 'firebaseui-angular';
import { FirebaseApp } from '@angular/fire';
import { AngularFireAuth } from '@angular/fire/auth';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.css']
})
export class SigninComponent implements OnInit {

  constructor(public user: UserService, private api: ApiConnectorService, private angularfire: AngularFireAuth) {
  }


  async onSocialLogin(event: any) {
    let socialuser = event.authResult.user;

    this.angularfire.signOut(); // Remove stored inecesarry data
    let social: SocialLogin = {
      uid: socialuser.uid,
      email: socialuser.email,
      name: socialuser.displayName
    };
    
    this.api.socialLogin(social);
  }
  ngOnInit(): void {
  }

}
