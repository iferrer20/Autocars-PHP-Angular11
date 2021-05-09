import { ApiConnectorService } from './../../services/api-connector.service';
import { Component, OnInit } from '@angular/core';

export interface CarList {
  cars: Array<Car>,
  pages: number
}

export interface CarSearch {
  text?: string,
  categories?: Array<string>,
  min_price?: number,
  max_price?: number,
  max_km?: number,
  order?: string,
  published?: string,
  brand?: string,
  page?: number
}

export interface Car {
  id: number,
  price: number,
  name: string,
  description: string,
  brand: number,
  category: string,
  km: number,
  views: number,
  at: string
}

@Component({
  selector: 'app-car-list',
  templateUrl: './car-list.component.html',
  styleUrls: ['./car-list.component.css']
})
export class CarListComponent implements OnInit {

  search: CarSearch = {
    page: 1
  };
  cars: Array<Car> = [];
  pages: number = 1;

  constructor(private service: ApiConnectorService) {
    
  }
  async searchCars() {
    try {
      let { cars, pages } = await this.service.searchCar(this.search);
      this.cars = cars;
      this.pages = pages;
      console.log(this.cars);
    } catch(e) {
      console.log(e);
    }
  }
  onChangePage(page: number) {
    this.search.page = page;
    this.searchCars();
  }

  async ngOnInit() {
    this.searchCars();
  }
}
