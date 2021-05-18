import { CarList, CarSearch } from './../components/car-list/car-list.component';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SocialLogin } from '../classes/socialLogin';


@Injectable({
  providedIn: 'root'
})
export class ApiConnectorService {
  base_url = "http://localhost/api/";
  constructor(private http: HttpClient) {
    
  }
  async req<obj>(uri: string, method: string, data: any) {
    let { content, success }:any = await this.http.request<obj>(method, this.base_url + uri, {
      body: data
    }).toPromise();
    return content;
  }

  searchCar(search: CarSearch): Promise<CarList> {
    return this.req<CarList>('cars/search', 'POST', search);
  }

  socialLogin(social: SocialLogin) {
    return this.req('user/signin_social', 'POST', social);
  }
}
