import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { Travel } from '../../model/travel/travel.model';

@Injectable()
export class TravelService {
  constructor(private http: Http) {

  }

  saveTravel(travel: Travel): Promise<Travel[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveTravel', JSON.stringify(travel))
      .toPromise()
      .then(response => response.json() as Travel[])
      .catch(this.handleError);
  }

  getTravels(): Promise<Travel[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getTravels')
      .toPromise()
      .then(response => response.json() as Travel[])
      .catch(this.handleError);
  }

  getTravelByID(travelId: number): Promise<Travel> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getTravelById/' + travelId)
      .toPromise()
      .then(response => response.json() as Travel)
      .catch(this.handleError);
  }

  removeTravel(travelId: number): Promise<Travel[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteTravel/' + travelId)
      .toPromise()
      .then(response => response.json() as Travel[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
