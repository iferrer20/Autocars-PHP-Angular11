import { SocialSignin } from './../../classes/socialSignin';
import { ApiConnectorService } from './../../services/api-connector.service';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { UserService } from 'src/app/services/user.service';
import { FirebaseuiAngularLibraryService, FirebaseUIModule, FirebaseUISignInSuccessWithAuthResult, NativeFirebaseUIAuthConfig } from 'firebaseui-angular';
import { FirebaseApp } from '@angular/fire';
import { AngularFireAuth } from '@angular/fire/auth';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.css']
})
export class SigninComponent implements OnInit, OnDestroy {

  socialSubscription: Subscription;

  constructor(public user: UserService, private api: ApiConnectorService, private angularfire: AngularFireAuth) {
    this.socialSubscription = this.angularfire.idToken.subscribe({
      next: (idToken: any) => {
        if (idToken) {
          this.onSocialSignin(idToken);
        }
      }
    });
  }


  async onSocialSignin(idToken: any) {
    let social: SocialSignin = {
      token: idToken
    };
    this.angularfire.signOut();

    await this.api.socialSignin(social);
  }
  ngOnInit(): void {
    this.angularfire.signOut();
  }
  ngOnDestroy() {
    this.socialSubscription.unsubscribe();
  }

}
