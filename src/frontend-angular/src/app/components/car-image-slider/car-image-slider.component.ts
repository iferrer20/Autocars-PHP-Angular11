import { Component, OnInit, ElementRef, ViewChild, AfterViewInit } from '@angular/core';

@Component({
  selector: 'app-car-image-slider',
  templateUrl: './car-image-slider.component.html',
  styleUrls: ['./car-image-slider.component.css']
})
export class CarImageSliderComponent implements OnInit, AfterViewInit {

  transform: number;
  nelements: number;
  pos: number;
  @ViewChild('slider') slider:ElementRef;

  sleep(ms: number) {
    return new Promise((res, rej) => {
      setTimeout(() => {
        res(true);
      }, ms);
    })
  }

  async run() {
    for (;;) {
        
        this.slider.nativeElement.style.transform = `translateX(-${this.transform}%)`;
        this.transform += 100/this.nelements;
        this.pos += 1;

        if (this.pos == this.nelements) {
            this.pos = 0;
            this.transform = 0;
        }
        await this.sleep(5000);
    }
}

  ngAfterViewInit() {
    this.nelements = this.slider.nativeElement.childElementCount;
    this.transform = 0;
    this.pos = 0;
    this.slider.nativeElement.style.width = `${this.nelements*100}%`;

    this.run();
  }
  ngOnInit(): void {
    
    //this.run();
  }


}
