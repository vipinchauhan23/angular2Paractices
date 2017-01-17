import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { EmployeeRecord } from '../../model/employee-record/employee-record.model';
import { Employee } from '../../model/employee/employee.model';
import { Qualification } from '../../model/qualification/qualification.model';

@Injectable()
export class EmployeeRecordService {
  constructor(private http: Http) {
  }
  saveEmployeeRecord(employee: EmployeeRecord): Promise<EmployeeRecord[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveEmployeeRecord', JSON.stringify(employee))
      .toPromise()
      .then(response => response.json() as EmployeeRecord[])
      .catch(this.handleError);
  }

getEmployees(): Promise<Employee[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getEmployees')
      .toPromise()
      .then(response => response.json() as Employee[])
      .catch(this.handleError);
  }
  getQualifications(): Promise<Qualification[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getQualifications')
      .toPromise()
      .then(response => response.json() as Qualification[])
      .catch(this.handleError);
  }
  getEmployeeRecords(): Promise<EmployeeRecord[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getEmployeeRecords')
      .toPromise()
      .then(response => response.json() as EmployeeRecord[])
      .catch(this.handleError);
  }

  getEmployeeRecordByID(employeeRecordId: number): Promise<EmployeeRecord> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getEmployeeRecordByID/' + employeeRecordId)
      .toPromise()
      .then(response => response.json() as EmployeeRecord)
      .catch(this.handleError);
  }

  removeEmployeeRecord(employeeRecordId: number): Promise<EmployeeRecord[]> {
    return this
      .http
      .delete(ApiUrl.baseUrl + 'deleteEmployeeRecord/' + employeeRecordId)
      .toPromise()
      .then(response => response.json() as EmployeeRecord[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
