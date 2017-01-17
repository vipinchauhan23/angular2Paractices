import {Http} from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { OnlineTest } from '../../model/online-test/online-test.model';

@Injectable()
export class OnlineTestService {
  constructor(private http: Http) {

  }

  saveOnlineTest(onlineTest: any): Promise<OnlineTest[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'onlineTest', onlineTest)
      .toPromise()
      .then(response => response.json() as OnlineTest[])
      .catch(this.handleError);
  }

  getOnlineTests(): Promise<OnlineTest[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getOnlineTests')
      .toPromise()
      .then(response => response.json() as OnlineTest[])
      .catch(this.handleError);
  }

  getOnlineTest(online_test_id: number): Promise<OnlineTest> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getOnlineTest/' + online_test_id)
      .toPromise()
      .then(response => response.json() as OnlineTest)
      .catch(this.handleError);
  }

  removeOnlineTest(id: any): Promise<OnlineTest[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'deletetest/' + id)
      .toPromise()
      .then(response => response.json() as OnlineTest[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
