import { Qualification } from '../qualification/qualification.model';
import { Employee } from '../employee/employee.model';

export class EmployeeRecord {
  employeerecord_id: number = 0;
  employee_id: number = 0;
  selectedQualifications: Array<number>;
  constructor() {
    this.selectedQualifications = new Array<number>();
  }
}
