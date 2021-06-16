import { UserSignup } from './../../classes/user';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent implements OnInit {
  success: boolean;
  userSignup: UserSignup;
  errors = {
    email: "⠀",
    username: "⠀",
    password: "⠀",
    retypePassword: "⠀",
    server: "⠀"
  }


  constructor(private user: UserService, public router: Router) {
    this.userSignup = {
      email: "",
      username: "",
      password: "",
      retypePassword: ""
    }
    this.success = false;
  }

  verifyEmail() {
    if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(this.userSignup.email)) {
      this.errors.email = "invalidemail";
      return false;
    }
    this.errors.email = "⠀";
    return true;
  }
  verifyUsername(): boolean {
    if (this.userSignup.username.length < 5) {
      this.errors.username = "usernameshort";
      return false;
    }
    this.errors.username = "⠀";
    return true;
  }
  verifyPassword(): boolean {
    if (this.userSignup.password.length < 5) {
      this.errors.password = "passwordshort";
      return false;
    }
    this.errors.password = "⠀";
    return true;
  }
  verifyRetypePassword() {
    if (this.userSignup.password != this.userSignup.retypePassword) {
      this.errors.retypePassword = "passwordmismach";
      return false;
    }
    this.errors.retypePassword = "⠀";
    return true;
  }
  onSignup() {
    let error = [
      this.verifyEmail(),
      this.verifyPassword(),
      this.verifyUsername(),
      this.verifyRetypePassword()
    ]
    if (error.every((e) => e)) {
      this.user.signup(this.userSignup)
      .then(() => {
        this.success = true;
      })
      .catch((e) => {
        this.errors.server = e;
      });
    }
    
    
  }
  ngOnInit(): void {
  }

}
