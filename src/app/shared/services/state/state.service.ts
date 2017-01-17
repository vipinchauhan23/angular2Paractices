import {Http} from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { Country } from '../../../shared/model/country/country.model';
import { State } from '../../../shared/model/state/state.model';

@Injectable()
export class StateService {
  constructor(private http: Http) {

  }

  saveState(state: State): Promise<State[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveState', JSON.stringify(state))
      .toPromise()
      .then(response => response.json() as State[])
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

  getState(): Promise<State[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getStates')
      .toPromise()
      .then(response => response.json() as State[])
      .catch(this.handleError);
  }

  getStateByID(stateId: number): Promise<State> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getState/' + stateId)
      .toPromise()
      .then(response => response.json() as State)
      .catch(this.handleError);
  }

  removeState(stateId: number): Promise<State[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteState/' + stateId)
      .toPromise()
      .then(response => response.json() as State[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
