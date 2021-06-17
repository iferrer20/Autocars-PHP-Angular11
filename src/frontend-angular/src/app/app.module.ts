
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './pages/home/home.component';
import { ShopComponent } from './pages/shop/shop.component';
import { CarListComponent } from './components/car-list/car-list.component';
import { CarModalComponent } from './components/car-modal/car-modal.component';
import { NotFoundComponent } from './pages/not-found/not-found.component';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { ApiConnectorService } from './services/api-connector.service';
import { TranslateLoader, TranslateModule } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { NavbarComponent } from './components/navbar/navbar.component';
import { AccountComponent } from './pages/account/account.component';
import { CarFilterComponent } from './components/car-filter/car-filter.component';
import { CarElementComponent } from './components/car-element/car-element.component';
import { NgxSliderModule } from '@angular-slider/ngx-slider';
import { SigninComponent } from './pages/signin/signin.component';
import { SignupComponent } from './pages/signup/signup.component';
import { AngularFireModule } from '@angular/fire';
import { environment } from 'src/environments/environment';
import firebase from 'firebase/app';
import { FirebaseUIModule, firebaseui } from 'firebaseui-angular';
import { FormsModule } from '@angular/forms';
import { PopupComponent } from './components/popup/popup.component';
import { CartComponent } from './pages/cart/cart.component';
import { CartElementComponent } from './components/cart-element/cart-element.component';
import { CartListComponent } from './components/cart-list/cart-list.component';
import { VerifyComponent } from './pages/verify/verify.component';
import { RecoverComponent } from './pages/recover/recover.component';
import { CarImageSliderComponent } from './components/car-image-slider/car-image-slider.component';
import { CategoriesComponent } from './components/categories/categories.component';

const firebaseUiAuthConfig: firebaseui.auth.Config = {
  signInFlow: 'popup',
  signInOptions: [
    firebase.auth.GoogleAuthProvider.PROVIDER_ID,
    firebase.auth.GithubAuthProvider.PROVIDER_ID
  ],
  tosUrl: '<your-tos-link>',
  privacyPolicyUrl: '<your-privacyPolicyUrl-link>',
  credentialHelper: firebaseui.auth.CredentialHelper.GOOGLE_YOLO
};


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    ShopComponent,
    CarListComponent,
    CarModalComponent,
    NotFoundComponent,
    NavbarComponent,
    AccountComponent,
    CarFilterComponent,
    CarElementComponent,
    SigninComponent,
    SignupComponent,
    PopupComponent,
    CartComponent,
    CartElementComponent,
    CartListComponent,
    VerifyComponent,
    RecoverComponent,
    CarImageSliderComponent,
    CategoriesComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: (http: HttpClient) => {
          return new TranslateHttpLoader(http);
        },
        deps: [ HttpClient ]
      }
    }),
    NgxSliderModule,
    AngularFireModule.initializeApp(environment.firebase),
    FirebaseUIModule.forRoot(firebaseUiAuthConfig),
    FormsModule
  ],
  providers: [ApiConnectorService],
  bootstrap: [AppComponent]
})
export class AppModule { }
