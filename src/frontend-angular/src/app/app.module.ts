
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './pages/home/home.component';
import { ShopComponent } from './pages/shop/shop.component';
import { CarListComponent } from './components/car-list/car-list.component';
import { CarModalComponent } from './components/car-modal/car-modal.component';
import { NotFoundComponent } from './pages/not-found/not-found.component';
import { HttpClientModule } from '@angular/common/http';
import { ApiConnectorService } from './services/api-connector.service';


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    ShopComponent,
    CarListComponent,
    CarModalComponent,
    NotFoundComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule
  ],
  providers: [ApiConnectorService],
  bootstrap: [AppComponent]
})
export class AppModule { }
