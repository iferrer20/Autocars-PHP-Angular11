import { EventBusService } from './event-bus.service';
import { Cart } from './../classes/cart';
import { Injectable } from '@angular/core';
import { Car, CarCart } from '../classes/car';
import { ApiConnectorService } from './api-connector.service';
import { UserService } from './user.service';

@Injectable({
  providedIn: 'root'
})
export class CartService {
  public cart: Cart;
  constructor(private api: ApiConnectorService,
              private user: UserService) {
    this.cart = {
      rows: {},
      totalPrice: 0,
      totalCount: 0
    }
  }

  save() {
    localStorage.setItem("cart", JSON.stringify(this.cart));
  }
  clear() {
    this.cart = {
      rows: {},
      totalCount: 0,
      totalPrice: 0
    };
    this.save();
  }

  async addCar(car: Car) {
    let row = this.cart.rows[car.car_id];
    if (row) {
      row.qty++;
    } else {
      this.cart.rows[car.car_id] = {
        car: car,
        qty: 1
      };
      row = this.cart.rows[car.car_id]; 
    }
    // this.eventBus.emit("newCarCart", car); // Emit event 
    if (this.user.isLogged()) {
      await this.api.addToCart(car.car_id, row.qty);
    }
    this.cart.totalCount++;
    this.cart.totalPrice += row.car.price;
    this.save();
  }
  async incQty(car: Car) {
    let row = this.cart.rows[car.car_id];
    row.qty++;
    this.cart.totalCount++;
    this.cart.totalPrice += row.car.price;
    this.save();
    if (this.user.isLogged()) {
      await this.api.addToCart(car.car_id, row.qty);
    }
  }
  async decQty(car: Car) {
    let row = this.cart.rows[car.car_id];
    if (row.qty != 1) {
      row.qty--;
      this.cart.totalCount--;
      this.cart.totalPrice -= row.car.price;

      if (this.user.isLogged()) {
        await this.api.addToCart(car.car_id, row.qty);
      }
      
      this.save();
    }
    
  }
  async delCar(car: Car) {
    if (this.user.isLogged()) {
      await this.api.delFromCart(car.car_id);
    }
    let row = this.cart.rows[car.car_id];
    this.cart.totalCount -= row.qty;
    this.cart.totalPrice -= row.car.price * row.qty;
    delete this.cart.rows[car.car_id];
    this.save();
  }

  async get() {
    
    let dataCart = localStorage.getItem("cart");
    if (dataCart) {
      this.cart = JSON.parse(dataCart);
    }
    
    if (this.user.isLogged()) {
      let cars = await this.api.getCart();
      this.cart = {
        rows: {},
        totalCount: 0,
        totalPrice: 0
      };
      
      cars.forEach((e:any) => {
        this.cart.rows[e.car_id] = {
          car: e,
          qty: e.qty
        }
      });
      Object.keys(this.cart.rows).forEach(key => (
        this.cart.totalCount += this.cart.rows[key].qty,
        this.cart.totalPrice += this.cart.rows[key].car.price * this.cart.rows[key].qty
      ));

    }


    
    this.save();
  }
}
