export class EmployeeTransaction {
  employee_transaction_id: number = 0;
  type: number = 0;
  employee_id: number = 0;
  amount: number = 0;
  date: string = '';
  pancard_no: string = '';
  grid_number: number = 0;
}

export class Employee {
  employee_id: number = 0;
  employee_name: string = '';
  email: string = '';
  mobile: string = '';
  gender: number = 0;
  balance: number = 0;
  pancard_no: string = '';
  country_id: number = 0;
  state_id: number = 0;
  city_id: number = 0;
}
