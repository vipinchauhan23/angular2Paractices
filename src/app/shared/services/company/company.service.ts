import {Http} from '@angular/http';
import {Injectable} from '@angular/core';

import { ApiUrl } from '../../api-url.component';
import { Company } from '../../model/company/company.model';

@Injectable()
export class CompanyService {
  constructor(private http: Http) {

  }

  getCompanies(): Promise<Company[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCompanies')
      .toPromise()
      .then(response => response.json() as Company[])
      .catch(this.handleError);
  }

  getCompanyById(companyId: number): Promise<Company> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getCompanyById/' + companyId)
      .toPromise()
      .then(response => response.json() as Company)
      .catch(this.handleError);
  }

  saveCompany(company: Company): Promise<number> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'company', company)
      .toPromise()
      .then(response => response.json() as number)
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
