import { CartService } from './../../services/cart.service';
import { EventBusService } from './../../services/event-bus.service';
import { PopupService } from './../../services/popup.service';
import { UserService } from './../../services/user.service';
import { ApiConnectorService } from './../../services/api-connector.service';
import { Car } from './../../classes/car';
import { Component, Input, OnInit } from '@angular/core';
import { EventData } from 'src/app/classes/eventData';

@Component({
  selector: 'app-car-element',
  templateUrl: './car-element.component.html',
  styleUrls: ['./car-element.component.css']
})
export class CarElementComponent implements OnInit {

  @Input() car!: Car;
  constructor(private api: ApiConnectorService, 
              private popup: PopupService,
              public cartService: CartService,
              private user: UserService) {
    
  }

  toggleFav(): void {
    if (this.user.isLogged()) {
      this.car.favorite = !this.car.favorite;
      if (this.car.favorite) {
        this.api.setFavoriteCar(this.car.car_id);
      } else {
        this.api.unsetFavoriteCar(this.car.car_id);
      }
    } else {
      this.popup.needLogin();
    }
    
  }

  async addToCart() {
    
    let resp = await this.popup.component.show("cart.askaddtocart", [
      {text: 'yes', background: 'black', accept: true},
      {text: 'no', background: 'black', close: true}
    ]);

    if (resp) {
      if (this.user.isLogged()) {
      }
      
      this.cartService.addCar(this.car);
    }
  }

  ngOnInit(): void {
  }

}
