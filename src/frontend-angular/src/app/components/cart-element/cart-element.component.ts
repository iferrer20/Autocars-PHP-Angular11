import { CarCart } from './../../classes/car';
import { Component, Input, OnInit } from '@angular/core';
import { CartService } from 'src/app/services/cart.service';

@Component({
  selector: 'app-cart-element',
  templateUrl: './cart-element.component.html',
  styleUrls: ['./cart-element.component.css']
})
export class CartElementComponent implements OnInit {
  @Input() carCart!: CarCart;
  disabledQtyButtons: boolean;
  constructor(private cartService: CartService) {
    this.disabledQtyButtons = false;
  }

  delete() {
    this.cartService.delCar(this.carCart.car);
  }
  async inc() {
    this.disabledQtyButtons = true;
    await this.cartService.incQty(this.carCart.car);
    this.disabledQtyButtons = false;
  }
  async dec() {
    this.disabledQtyButtons = true;
    await this.cartService.decQty(this.carCart.car);
    this.disabledQtyButtons = false;
  }

  ngOnInit(): void {
  }

}
