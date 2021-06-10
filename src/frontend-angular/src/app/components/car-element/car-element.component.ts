import { PopupService } from './../../services/popup.service';
import { UserService } from './../../services/user.service';
import { ApiConnectorService } from './../../services/api-connector.service';
import { Car } from './../../classes/car';
import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-car-element',
  templateUrl: './car-element.component.html',
  styleUrls: ['./car-element.component.css']
})
export class CarElementComponent implements OnInit {

  @Input() car!: Car;
  constructor(private api: ApiConnectorService, private user: UserService, private popup: PopupService) {
    
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

  ngOnInit(): void {
  }

}
