import { Car, CarList, CarSearch } from './../../classes/car';
import { ApiConnectorService } from './../../services/api-connector.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-car-list',
  templateUrl: './car-list.component.html',
  styleUrls: ['./car-list.component.css']
})
export class CarListComponent implements OnInit {

  search: CarSearch;
  carlist: CarList;

  constructor(private api: ApiConnectorService) {
    this.carlist = {
      cars: [],
      pages: 1
    }
    this.search = {
      page: 1,
      categories: [],
      min_price: 500,
      max_price: 20000
    };
  }

  
  async searchCars() {
    try {
      this.carlist = await this.api.searchCar(this.search);
    } catch(e) {
      console.log(e);
    }
  }
  onChangeFilters() {
    this.search.page = 1;
    this.searchCars(); 
  }
  onChangePage(page: number) {
    this.search.page = page;
    this.searchCars();
  }

  ngOnInit() {
    this.searchCars();
  }
}
