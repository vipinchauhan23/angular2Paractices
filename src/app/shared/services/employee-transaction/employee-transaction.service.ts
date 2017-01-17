import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { EmployeeTransaction, Employee } from '../../model/employee-transaction/employee-transaction.model';


@Injectable()
export class EmployeeTransactionService {
  constructor(private http: Http) {
  }
  saveEmployeeTransaction(employeeTransaction: EmployeeTransaction): Promise<EmployeeTransaction[]> {
    return this.http
      .post(ApiUrl.baseUrl + 'saveEmployeeTransaction', JSON.stringify(employeeTransaction))
      .toPromise()
      .then(response => response.json() as EmployeeTransaction[])
      .catch(this.handleError);
  }

getEmployees(): Promise<Employee[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getEmployees')
      .toPromise()
      .then(response => response.json() as Employee[])
      .catch(this.handleError);
  }
  getEmployeeTransactions(): Promise<EmployeeTransaction[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getEmployeeTransactions')
      .toPromise()
      .then(response => response.json() as EmployeeTransaction[])
      .catch(this.handleError);
  }

  // checkDayTransaction( empID: number, date: string): Promise<EmployeeTransaction[] > {
  //  return this.http
  //     .get(ApiUrl.baseUrl + 'checkDayTransaction/' + empID + '/' + date)
  //     .toPromise()
  //     .then(response => response.json() as EmployeeTransaction [] )
  //     .catch(this.handleError);
  // }

  getEmployeeTransactionByID(empTransactionID: number): Promise<EmployeeTransaction> {
    return this.http
      .get(ApiUrl.baseUrl + 'getEmpTransactionByID/' + empTransactionID)
      .toPromise()
      .then(response => response.json() as EmployeeTransaction)
      .catch(this.handleError);
  }

  removeEmployeeTransaction(empTransactionID: number): Promise<EmployeeTransaction[]> {
    return this.http
      .delete(ApiUrl.baseUrl + 'deleteEmployeeTransaction/' + empTransactionID)
      .toPromise()
      .then(response => response.json() as EmployeeTransaction[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
