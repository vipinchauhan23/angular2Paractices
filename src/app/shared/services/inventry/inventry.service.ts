import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { Inventry, Item} from '../../model/inventry/inventry.model';


@Injectable()
export class InventryService {
  constructor(private http: Http) {
  }
  saveInventry(inventry: Inventry): Promise<Inventry[]> {
    return this.http
      .post(ApiUrl.baseUrl + 'saveInventry', JSON.stringify(inventry))
      .toPromise()
      .then(response => response.json() as Inventry[])
      .catch(this.handleError);
  }

getItems(): Promise<Item[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getItems')
      .toPromise()
      .then(response => response.json() as Item[])
      .catch(this.handleError);
  }
  getInventries(): Promise<Inventry[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getInventries')
      .toPromise()
      .then(response => response.json() as Inventry[])
      .catch(this.handleError);
  }

  getInventryByID(inventryId: number): Promise<Inventry> {
    return this.http
      .get(ApiUrl.baseUrl + 'getInventryByID/' + inventryId)
      .toPromise()
      .then(response => response.json() as Inventry)
      .catch(this.handleError);
  }

  deleteInventry(inventryId: number): Promise<Inventry[]> {
    return this.http
      .delete(ApiUrl.baseUrl + 'deleteInventry/' + inventryId)
      .toPromise()
      .then(response => response.json() as Inventry[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
