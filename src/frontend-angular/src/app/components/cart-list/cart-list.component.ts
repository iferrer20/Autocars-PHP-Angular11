import { PopupService } from './../../services/popup.service';
import { UserService } from './../../services/user.service';
import { CartService } from './../../services/cart.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-cart-list',
  templateUrl: './cart-list.component.html',
  styleUrls: ['./cart-list.component.css']
})
export class CartListComponent implements OnInit {

  constructor(private user: UserService, public cartService: CartService, private popup: PopupService) {
  }

  onCheckout() {
    if (!this.user.isLogged()) {
      this.popup.needLogin();
      return;
    }
    this.cartService.checkout();

    
  }

  ngOnInit(): void {

  }

}
