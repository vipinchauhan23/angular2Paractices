import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { Qualification } from '../../model/qualification/qualification.model';

@Injectable()
export class QualificationService {
  constructor(private http: Http) {
  }

  saveQualification(qualification: Qualification): Promise<Qualification[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveQualification', JSON.stringify(qualification))
      .toPromise()
      .then(response => response.json() as Qualification[])
      .catch(this.handleError);
  }

  getQualification(): Promise<Qualification[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getQualifications')
      .toPromise()
      .then(response => response.json() as Qualification[])
      .catch(this.handleError);
  }

  getQualificationByID(qualificationId: number): Promise<Qualification> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getQualification/' + qualificationId)
      .toPromise()
      .then(response => response.json() as Qualification)
      .catch(this.handleError);
  }

  removeQualification(qualificationId: number): Promise<Qualification[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteQualification/' + qualificationId)
      .toPromise()
      .then(response => response.json() as Qualification[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
