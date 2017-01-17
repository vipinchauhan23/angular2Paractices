import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Country } from '../../../shared/model/country/country.model';
import { State } from '../../../shared/model/state/state.model';
import { City } from '../../../shared/model/city/city.model';
import { CityService } from '../../../shared/services/city/city.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-city',
  templateUrl: 'city.component.html'
})
export class CityComponent extends BaseComponent implements OnInit {
  private model: City;
  private btnText: string;
  private stateId: number;
  private cityId: number;
  private states: State[] = [];
  private countries: Country[] = [];
  private stateByCountry : State[] = [];

  constructor(private cityService: CityService, private messageService: MessageService,
    private activatedRoute: ActivatedRoute,

    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new City();
    this.states = new Array<State>();
    this.countries = new Array<Country>();
    this.stateByCountry = new Array<State>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.cityId = +params['cityId']; // (+) converts string 'id' to a number
      });
      this.getCountries();
    }
  }

  saveCity(): void {
    if (this.model.state_id == 0 || this.model.state_id == undefined) {
      this.messageService.showMessage('Please select state');
      return;
    }
    if (this.model.city_name == '' || this.model.city_name == undefined) {
      this.messageService.showMessage('Please enter city');
      return;
    }
    this.cityService
      .saveCity(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage(this.btnText + ' successfully');
          this.router.navigate(['/city']);
        } else {
          this.messageService.showMessage(this.btnText + ' successfully');
        }
      });
  }

  private getCountries(): void {
    this.cityService
      .getCountries()
      .then(result => {
        this.countries = result;
        this.getStates();
      });
  }

  private getStates(): void {
    this.cityService
      .getStates()
      .then(result => {
        this.states = result;
        if (this.cityId && this.cityId !== 0) {
          this.getCityByID(this.cityId);
          this.btnText = 'Update City';
        } else {
          this.btnText = 'Save City';
        }
      });
  }

  private countrySelected(countryID: number) {
    console.log(this.states +" country" +countryID  );
   this.stateByCountry = this.states.filter(function (item) {
     return item.country_id == countryID;
    })
    console.log(this.stateByCountry);
  }

  private getCityByID(cityId: number): void {
    this.cityService
      .getCityByID(cityId)
      .then(result => {
        this.model = result[0];
      });
  }
}
