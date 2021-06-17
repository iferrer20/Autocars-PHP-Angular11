import { Location } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-categories',
  templateUrl: './categories.component.html',
  styleUrls: ['./categories.component.css']
})
export class CategoriesComponent implements OnInit {

  constructor(public router: Router) {

  }

  goCategory(category: string) {
    this.router.navigate(['/shop/', btoa(JSON.stringify({
      categories: [category]
    }))]);
  }

  ngOnInit(): void {
    
  }

}
