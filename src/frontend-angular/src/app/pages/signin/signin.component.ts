import { CartService } from 'src/app/services/cart.service';
import { UserSignin, UserSocialSignin } from './../../classes/user';
import { ApiConnectorService } from './../../services/api-connector.service';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { UserService } from 'src/app/services/user.service';
import { FirebaseuiAngularLibraryService, FirebaseUIModule, FirebaseUISignInSuccessWithAuthResult, NativeFirebaseUIAuthConfig } from 'firebaseui-angular';
import { FirebaseApp } from '@angular/fire';
import { AngularFireAuth } from '@angular/fire/auth';
import { Subscription } from 'rxjs';
import { Router } from '@angular/router';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.css']
})
export class SigninComponent implements OnInit, OnDestroy {

  socialSubscription: Subscription;
  userSignin: UserSignin;
  error: string;

  constructor(public user: UserService, 
              private angularfire: AngularFireAuth, 
              public router: Router, 
              private cartService: CartService) {
    this.socialSubscription = this.angularfire.idToken.subscribe({
      next: (idToken: any) => {
        if (idToken) {
          this.onSocialSignin(idToken);
        }
      }
    });
    this.userSignin = {
      email: "",
      password: ""
    }
    this.error = "⠀";
  }

  onSocialSignin(idToken: any) {
    let social: UserSocialSignin = {
      token: idToken
    };
    this.angularfire.signOut();

    this.user.socialSignin(social)
    .then(() => {
      this.cartService.get();
      this.router.navigate(['/shop/']);
    })
    .catch((e) => {
      this.error = e;
    });
  }
  onSignin() {
    this.user.signin(this.userSignin)
    .then(() => {
      this.cartService.get();
      this.router.navigate(['/shop/']);
    })
    .catch((e) => {
      this.error = e;
    });
    
  }
  ngOnInit(): void {
    this.angularfire.signOut();
  }
  ngOnDestroy() {
    this.socialSubscription.unsubscribe();
  }

}
