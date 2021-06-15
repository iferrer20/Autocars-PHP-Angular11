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
  
  userSignup: UserSignup;
  errors = {
    email: "⠀",
    password: "⠀",
    retypePassword: "⠀"
  }

  constructor(private user: UserService, public router: Router) {
    this.userSignup = {
      email: "",
      username: "",
      password: "",
      retypePassword: ""
    }
  }

  verifySignup() {
    
  }
  async onSignup() {
    this.verifySignup();
    try {
      await this.user.signup(this.userSignup);
    } catch(e) {
      console.log(e);
    }
    
  }
  ngOnInit(): void {
  }

}
