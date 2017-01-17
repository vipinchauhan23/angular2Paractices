import {Http} from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { Country } from '../../../shared/model/country/country.model';
import { State } from '../../../shared/model/state/state.model';
import { City } from '../../../shared/model/city/city.model';

@Injectable()
export class CityService {
  constructor(private http: Http) {

  }

  saveCity(city: City): Promise<City[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveCity', JSON.stringify(city))
      .toPromise()
      .then(response => response.json() as City[])
      .catch(this.handleError);
  }
  
   getCountries(): Promise<Country[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCountries')
      .toPromise()
      .then(response => response.json() as Country[])
      .catch(this.handleError);
  }

  getStates(): Promise<State[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getStates')
      .toPromise()
      .then(response => response.json() as State[])
      .catch(this.handleError);
  }

  getCities(): Promise<City[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCities')
      .toPromise()
      .then(response => response.json() as City[])
      .catch(this.handleError);
  }

  getCityByID(cityId: number): Promise<City> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCity/' + cityId)
      .toPromise()
      .then(response => response.json() as City)
      .catch(this.handleError);
  }

  removeCity(cityId: number): Promise<City[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteCity/' + cityId)
      .toPromise()
      .then(response => response.json() as City[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
