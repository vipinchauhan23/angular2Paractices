import {Http} from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { Country } from '../../model/country/country.model';

@Injectable()
export class CountryService {
  constructor(private http: Http) {

  }

  saveCountry(country: Country): Promise<Country[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveCountry', JSON.stringify(country))
      .toPromise()
      .then(response => response.json() as Country[])
      .catch(this.handleError);
  }

  getCountry(): Promise<Country[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCountries')
      .toPromise()
      .then(response => response.json() as Country[])
      .catch(this.handleError);
  }

  getCountryByID(countryId: number): Promise<Country> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCountry/' + countryId)
      .toPromise()
      .then(response => response.json() as Country)
      .catch(this.handleError);
  }

  removeCountry(countryId: number): Promise<Country[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteCountry/' + countryId)
      .toPromise()
      .then(response => response.json() as Country[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
