import { UserSocialSignin, UserSignin, UserSignup } from './../classes/user';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { UserService } from './user.service';
import { CarList, CarSearch } from '../classes/car';


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
      console.log(content);
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

  setFavoriteCar(car_id: string) {
    return this.req<CarList>('cars/favorite', 'PUT', {car_id: car_id})
  }

  // FAV
  unsetFavoriteCar(car_id: string) {
    return this.req<CarList>('cars/favorite', 'DELETE', {car_id: car_id})
  }

  //CART
  getCart() {
    return this.req('cart/get', 'GET', null);
  }

  addToCart(car_id: string, qty: number=1) {
    return this.req('cart/add_car', 'PUT', {car_id: car_id, qty: qty});
  }

  delFromCart(car_id: string) {
    return this.req('cart/del_car', 'DELETE', {car_id: car_id});
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

  userLogout() {
    return this.req('user/logout', 'GET', null);
  }

  userVerify(token: string) {
    return this.req('user/verify', 'POST', {token: token});
  }

}
