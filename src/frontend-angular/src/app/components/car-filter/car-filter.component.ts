import { CarSearch } from './../car-list/car-list.component';
import { Component, OnInit, Input, Output, EventEmitter, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import { Options } from '@angular-slider/ngx-slider';

@Component({
  selector: 'app-car-filter',
  templateUrl: './car-filter.component.html',
  styleUrls: ['./car-filter.component.css']
})
export class CarFilterComponent implements OnInit {
  @Input() search!: CarSearch;
  @Output() searchEvent: EventEmitter<CarSearch> = new EventEmitter();

  categoryOpened: boolean = false;
  priceOpened: boolean = false;
  postedOpened: boolean = false;
  orderbyOpened: boolean = false;
  
  categories: string[] = [
    "offroad",
    "van",
    "minivan",
    "sporty"
  ];

  publishedOps: string[] = [
    "today",
    "week",
    "month",
    "year"
  ];

  sortingOps: string[] = [
    "expensive",
    "leastkm",
    "mostkm",
    "cheaper",
    "popularity",
    "recent"
  ];

  sliderLimits = {
    min: 500,
    max: 100000
  }

  rangeSliderOptions: Options = {
      floor: 0,
      ceil: this.sliderLimits.max,
      minLimit: this.sliderLimits.min
  };
  
  constructor() {
  }
  setText(str: string) {
    this.search.text = str;
    this.searchEmit();
  }

  setCategory(category: string) {
    
    if (!this.search.categories.includes(category)) {
      this.search.categories.push(category);
    } else {
      this.search.categories.splice(this.search.categories.indexOf(category), 1);
    }
    //this.categoryOpened = false;
    this.searchEmit();
  }

  setPublished(publishedOp: string) {
    if (this.search.published != publishedOp) {
      this.search.published = publishedOp;
    } else {
      delete this.search.published;
    }
    this.postedOpened = false;
    this.searchEmit();
  }

  setSort(sortOp: string) {
    if (this.search.sort != sortOp) {
      this.search.sort = sortOp;
    } else {
      delete this.search.sort;
    }
    this.orderbyOpened = false;
    this.searchEmit();
  }

  onApplyPrice() {
    this.priceOpened = false;
    this.searchEmit();
  }

  searchEmit() {
    this.searchEvent.emit(this.search);
  }
  ngOnInit(): void {
    //console.log(this.search);
  }
}
