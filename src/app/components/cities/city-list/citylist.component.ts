import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { City } from '../../../shared/model/city/city.model';
import { CityService } from '../../../shared/services/city/city.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-statelist',
  templateUrl: 'citylist.component.html',
})
export class CityListComponent extends BaseComponent implements OnInit {
  private selectedCity: City;
  private model: City[] = [];

  constructor(private stateService: CityService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedCity = new City();
    this.model = new Array<City>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getCities();
    }
  }

  editCity(cityId: number): void {
    this.router.navigate(['/city', cityId]);
  }

  showCity(): void {
    this.router.navigate(['/city', 0]);
  }

  removeItem(item: City): void {
    var yes = confirm("Are you sure you want to delete?");
    if (yes)
      this.stateService
        .removeCity(item.city_id)
        .then(result => {
          if (result) {
            this.messageService.showMessage('City deleted!');
            this.getCities();
          } else {
            this.messageService.showMessage('City not deleted!');
          }
        });
    else {

    }

  }


  private getCities(): void {
    this.stateService
      .getCities()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
