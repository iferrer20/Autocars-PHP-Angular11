import { CarList, CarSearch } from './../components/car-list/car-list.component';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';


@Injectable({
  providedIn: 'root'
})
export class ApiConnectorService {
  base_url = "http://localhost/api/";
  options = {

  };
  constructor(private http: HttpClient) {
    
  }
  async req<obj>(uri: string, method: string, data: Object) {
    let { content, success }:any = await this.http.request<obj>(method, this.base_url + uri, {
      body: data
    }).toPromise();
    return content;
  }

  searchCar(search: any) {
    return this.req<CarList>('cars/search', 'POST', search);
  }
}
