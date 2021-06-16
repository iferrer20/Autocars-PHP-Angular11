import { ActivatedRoute, Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { ApiConnectorService } from 'src/app/services/api-connector.service';

@Component({
  selector: 'app-recover',
  templateUrl: './recover.component.html',
  styleUrls: ['./recover.component.css']
})
export class RecoverComponent implements OnInit {
  email: string;
  success: boolean;
  token!: string;
  password: string;
  retypePassword: string;
  error: any;

  constructor(public router: Router, private api: ApiConnectorService, private actRoute: ActivatedRoute) {
    this.email = '';
    this.error = '';
    this.password = '';
    this.retypePassword = '';
    this.success = false;
    this.token = atob(this.actRoute.snapshot.params.token);
    this.error = {
      email: '⠀',
      password: '⠀'
    };
  }

  sendRecover() {
    this.api.userSendRecover(this.email)
    .then(() => {
      this.success = true;
    })
    .catch((e) => {
      this.error = e;
    });
  }
  checkPasswords(): boolean {
    if (this.password != this.retypePassword) {
      this.error.password = "Password mismatch";
      return false;
    }

    if (this.password.length < 5) {
      this.error.password = "Password too short";
      return false;
    }
    
    return true;

  }

  chPasswd() {
    if (this.checkPasswords()) {
      this.api.userChangePass(this.token, this.password)
      .then(() => {
        this.success = true;
      })
      .catch((e) => {
        this.error.password = e;
      });
    }
    
  }
  ngOnInit(): void {
  }

}
