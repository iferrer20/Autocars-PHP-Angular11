import { Observable } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { PopupService } from './../../services/popup.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-popup',
  templateUrl: './popup.component.html',
  styleUrls: ['./popup.component.css']
})
export class PopupComponent implements OnInit {
  public text!: string;
  public displayed!: boolean;
  public buttons!: Array<any>;
  private promise!: Promise<any>;
  public accept!: Function;
  public close!: Function;
  
  constructor(private service: PopupService) {
    this.service.setPopupComponent(this);  
  }

  ngOnInit(): void {
  }

  show(text: string, buttons: Array<any>) {
    this.text = text;
    this.buttons = buttons;
    this.displayed = true;
    
    var self = this;
    const promise = new Promise(function(res) {
      self.accept = () => { 
        res(true); 
        self.displayed = false; 
      };
      self.close = () => {
        res(false);
        self.displayed = false;
      }
    });

    return promise;
  }


}
