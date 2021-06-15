import { CartService } from './../../services/cart.service';
import { EventBusService } from './../../services/event-bus.service';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {
  
  activeLang: string = 'es';

  constructor(private translate: TranslateService, 
              public router: Router, 
              public cartService: CartService) {
    this.translate.setDefaultLang(this.activeLang);
  }

  changeLang(lang:string) {
    this.activeLang = lang;
    this.translate.use(lang);
  }

  ngOnInit(): void {
  }

}
