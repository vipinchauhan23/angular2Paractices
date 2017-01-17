import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { Country } from '../../../shared/model/country/country.model';
import { CountryService } from '../../../shared/services/country/country.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
  moduleId: module.id,
  selector: 'app-countrylist',
  templateUrl: 'countrylist.component.html',
})
export class CountryListComponent extends BaseComponent implements OnInit {
  private selectedCountry: Country;
  private model: Country[] = [];

  constructor(private countryService: CountryService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedCountry = new Country();
    this.model = new Array<Country>();
  }

  ngOnInit(): void {
    if (this.user) {
      this.getCountry();
    }
  }

  editCountry(countryId: number): void {
    this.router.navigate(['/country', countryId]);
  }

  showCountry(): void {
    this.router.navigate(['/country', 0]);
  }

  removeItem(item: Country): void {
    this.countryService
      .removeCountry(item.country_id)
      .then(result => {
        if (result) {
          this.messageService.showMessage('Country deleted!');
          this.getCountry();
        } else {
          this.messageService.showMessage('Country not deleted!');
        }
      });
  }

  private getCountry(): void {
    this.countryService
      .getCountry()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
