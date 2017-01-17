import { Injectable } from '@angular/core';
import { Http } from '@angular/http';
import 'rxjs/add/operator/map';

import { ApiUrl } from '../../../shared/api-url.component';
import { Login } from './login.model';

@Injectable()
export class LoginService {
  constructor(
    private http: Http) {
  }

  login(data: Login): Promise<any> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'login', JSON.stringify(data))
      .toPromise()
      .then(res => res.json())
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
