import { Http } from '@angular/http';
import { Injectable } from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { Employee } from '../../model/employee-transaction/employee-transaction.model';
import { Country } from '../../../shared/model/country/country.model';
import { State } from '../../../shared/model/state/state.model';
import { City } from '../../../shared/model/city/city.model';

@Injectable()
export class EmployeeDetailService {
  constructor(private http: Http) {
  }
  getCountries(): Promise<Country[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getCountries')
      .toPromise()
      .then(response => response.json() as Country[])
      .catch(this.handleError);
  }
  getStates(): Promise<State[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getStates')
      .toPromise()
      .then(response => response.json() as State[])
      .catch(this.handleError);
  }
  getCities(): Promise<City[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getCities')
      .toPromise()
      .then(response => response.json() as City[])
      .catch(this.handleError);
  }

  getEmployees(): Promise<Employee[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getEmployeesDetails')
      .toPromise()
      .then(response => response.json() as Employee[])
      .catch(this.handleError);
  }

  saveEmployeeDetails(employee: Employee): Promise<Employee[]> {
    return this.http
      .post(ApiUrl.baseUrl + 'saveEmployeeDetails', JSON.stringify(employee))
      .toPromise()
      .then(response => response.json() as Employee[])
      .catch(this.handleError);
  }

  login(data: any): Promise<any[]> {
    return this.http
      .post('https://sync.advbackoffice.com:8443/RestFulMobileService/RestFulService/AdvMobileRestWMDataService.svc/checkauthentication'
      + data.username, true, data.password)
      .toPromise()
      .then(response => response.json() as any[])
      .catch(this.handleError);
  }

  removeEmployeeTransaction(empTransactionID: number): Promise<Employee[]> {
    return this.http
      .delete(ApiUrl.baseUrl + 'deleteEmployeeTransaction/' + empTransactionID)
      .toPromise()
      .then(response => response.json() as Employee[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
