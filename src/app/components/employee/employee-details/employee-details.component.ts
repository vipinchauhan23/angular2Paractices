import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Country } from '../../../shared/model/country/country.model';
import { State } from '../../../shared/model/state/state.model';
import { City } from '../../../shared/model/city/city.model';
import { Employee } from '../../../shared/model/employee-transaction/employee-transaction.model';
import { EmployeeDetailService } from '../../../shared/services/employee-details/employee-details.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'employee-details',
  templateUrl: 'employee-details.component.html'
})
export class EmployeeDetailsComponent extends BaseComponent implements OnInit {
  private selectedCity: City;
  private model: Employee[] = [];
  private countries: Country[] = [];
  private states: State[] = [];
  private cities: City[] = [];
  private loginObj: any;
  // private password: string;

  constructor(private employeeDetailService: EmployeeDetailService,
    private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    // this.selectedCity = new City();
    this.countries = new Array<Country>();
    this.states = new Array<State>();
    this.cities = new Array<City>();
    this.model = new Array<Employee>();
    this.loginObj = {
      username: 'satishba',
      password: 'abc123'
    };
  }

  ngOnInit(): void {
    if (this.user) {
      this.login();
    }
  }
  private login() {
    this.employeeDetailService.login(this.loginObj).then(result => {
      if (result) {
        console.log(result);
      }
    });
  }
  //   private getCountries(): void {
  //     this.employeeDetailService
  //       .getCountries()
  //       .then(result => {
  //         this.countries = result;
  //         this.getStates();
  //       });
  //   }

  //   private getStates(): void {
  //     this.employeeDetailService
  //       .getStates()
  //       .then(result => {
  //         this.states = result;
  //          this.getCities();
  //       });
  //   }

  // private getCities(): void {
  //     this.employeeDetailService
  //       .getCities()
  //       .then(result => {
  //         this.cities = result;
  //       });
  //   }
  // private countrySelected(countryID: number) {
  //   console.log(this.states + " country" + countryID);
  //   this.stateByCountry = this.states.filter(function (item) {
  //     return item.country_id == countryID;
  //   })
  //   console.log(this.stateByCountry);
  // }

  // private getEmployees(): void {
  //   this.employeeDetailService
  //     .getEmployees()
  //     .then(result => {
  //       if (result) {
  //         this.model = result;
  //       }
  //     });
  // }
}
