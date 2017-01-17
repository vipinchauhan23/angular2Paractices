import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent} from '../../base.component';
import { Country } from '../../../shared/model/country/country.model';
import { CountryService } from '../../../shared/services/country/country.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-country',
  templateUrl:'country.component.html'
})
export class CountryComponent extends BaseComponent implements OnInit {
  private model: Country;
  private btnText: string;
  private countryId: number;

  constructor(private countryService: CountryService, private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Country();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.countryId = +params['countryId']; // (+) converts string 'id' to a number
      });
      if (this.countryId && this.countryId !== 0) {
        this.getCountryByID(this.countryId);
        this.btnText = 'Update Country';
      } else {
        this.btnText = 'Save Country';
      }
    }
  }

  saveCountry(): void {
    if (this.model.country_name === '' || this.model.country_name === undefined) {
      this.messageService.showMessage('Please enter country name');
      return;
    }
     if (this.model.country_code == '' || this.model.country_code == undefined) {
      this.messageService.showMessage('Please enter country code');
      return;
    }
    this.countryService
      .saveCountry(this.model)
      .then(result => {
        if (result) {
          this.messageService.showMessage(this.btnText + ' successfully');
           this.router.navigate(['/country']);
        } else {
            this.messageService.showMessage(this.btnText + ' successfully');
        }
      });
  }

  private getCountryByID(countryId: number): void {
    this.countryService
      .getCountryByID(countryId)
      .then(result => {
        this.model = result[0];
      });
  }

}
