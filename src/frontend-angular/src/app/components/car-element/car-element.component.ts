import { Component, Input, OnInit } from '@angular/core';

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
  selector: 'app-car-element',
  templateUrl: './car-element.component.html',
  styleUrls: ['./car-element.component.css']
})
export class CarElementComponent implements OnInit {

  @Input() car: Car;
  constructor() {
    this.car = {
      id: 0,
      price: 0,
      name: '',
      description: '',
      brand: 0,
      category: '',
      km: 0,
      views: 0,
      at: ''
    }
  }

  ngOnInit(): void {
  }

}
