import { PopupComponent } from './../components/popup/popup.component';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class PopupService {
  component!: PopupComponent;
  constructor(private route: Router) { }

  setPopupComponent(component: PopupComponent) {
    this.component = component;
  }

  async needLogin() {
    let accepted = await this.component.show("popup.needlogin", [
      {text: 'signin', background: 'red', accept: true},
      {text: 'cancel', background: 'red', close: true}
    ]);

    if (accepted) {
      this.route.navigate(['/signin/']);
    }


  }
}
