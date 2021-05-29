import { ApiConnectorService } from './../../services/api-connector.service';
import { UserSignup } from './../../classes/user';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

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

  constructor(private api: ApiConnectorService, public router: Router) {
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
      await this.api.userSignup(this.userSignup);
    } catch(e) {
      console.log(e);
    }
    
  }
  ngOnInit(): void {
  }

}
