import { ApiConnectorService } from './../../services/api-connector.service';
import { Subscription } from 'rxjs';
import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Route } from '@angular/compiler/src/core';

@Component({
  selector: 'app-verify',
  templateUrl: './verify.component.html',
  styleUrls: ['./verify.component.css']
})
export class VerifyComponent implements OnInit, OnDestroy {
  private token!: string;
  public error!: boolean;
  public success!: boolean;

  constructor(private url: ActivatedRoute, private api: ApiConnectorService, public router: Router) { }

  async verify() {
    try {
      await this.api.userVerify(this.token);
      this.success = true;
    } catch(e) {
      this.error = true;
    }
  }

  ngOnInit(): void {
    this.token = atob(this.url.snapshot.params.token);
    this.verify();
  }
  ngOnDestroy() {
  }

}
