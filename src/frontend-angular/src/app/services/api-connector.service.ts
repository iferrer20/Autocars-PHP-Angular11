import { UserSocialSignin, UserSignin, UserSignup } from './../classes/user';
import { CarList, CarSearch } from './../components/car-list/car-list.component';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { UserService } from './user.service';


@Injectable({
  providedIn: 'root'
})
export class ApiConnectorService {
  base_url = "http://localhost/api/";
  constructor(private http: HttpClient) {
    
  }
  async req<obj>(uri: string, method: string, data: any) {
    try {
      let { content, success }:any = await this.http.request<obj>(method, this.base_url + uri, {
        body: data
      }).toPromise();
      return content;
    } catch(e) {
      console.log(e);
      throw e.error.error;
    }
  }

  //CAR
  searchCar(search: CarSearch): Promise<CarList> {
    return this.req<CarList>('cars/search', 'POST', search);
  }

  setFavoriteCar(car_id: number) {
    return this.req<CarList>('cars/favorite', 'PUT', {car_id: car_id})
  }

  unsetFavoriteCar(car_id: number) {
    return this.req<CarList>('cars/favorite', 'DELETE', {car_id: car_id})
  }

  //USER
  userSocialSignin(social: UserSocialSignin) {
    return this.req('user/social_signin', 'POST', social);
  }

  userSignin(userSignin: UserSignin) {
    return this.req('user/signin', 'POST', userSignin);
  }

  userSignup(userSignup: UserSignup) {
    return this.req('user/signup', 'POST', userSignup);
  }

  


}
