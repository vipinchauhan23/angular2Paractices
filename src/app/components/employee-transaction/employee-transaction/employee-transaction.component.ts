import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { EmployeeTransactionService } from '../../../shared/services/employee-transaction/employee-transaction.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { EmployeeTransaction, Employee } from '../../../shared/model/employee-transaction/employee-transaction.model';

export enum Gender {
  Female = 0,
  Male = 1
}
export enum TransactionType {
  Deposit = 1,
  Withdrawal = 2
}

export class EnumEx {
  static getNamesAndValues<T extends number>(e: any) {
    return EnumEx.getNames(e).map(n => ({ name: n, value: e[n] as T }));
  }

  static getNames(e: any) {
    return EnumEx.getObjValues(e).filter(v => typeof v === 'string') as string[];
  }

  static getValues<T extends number>(e: any) {
    return EnumEx.getObjValues(e).filter(v => typeof v === 'number') as T[];
  }

  private static getObjValues(e: any): (number | string)[] {
    return Object.keys(e).map(k => e[k]);
  }
}

@Component({
  moduleId: module.id,
  selector: 'employee-transaction',
  templateUrl: 'employee-transaction.component.html',
})
export class EmployeeTransactionComponent extends BaseComponent implements OnInit {

  private model: EmployeeTransaction;
  private employeeArray: Employee[] = [];
  private showGrid: any[][];
  private btnText: string;
  private empTransationId: number;
  private selectedEmployee: Employee;
  private backwordDiagnal = 0;
  private forwordDiagnal = 0;

  private transactionTypes: Array<any> = EnumEx.getNamesAndValues<TransactionType>(TransactionType);

  constructor(private employeeTransactionService: EmployeeTransactionService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new EmployeeTransaction();
    this.employeeArray = Array<Employee>();
  }

  public ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.empTransationId = +params['empTransactionId']; // (+) converts string 'id' to a number
      });
      this.getEmployee();
      if (this.empTransationId && this.empTransationId !== 0) {
        this.getEmployeeTransactionByID(this.empTransationId);
        this.btnText = 'Update Employee Transaction';
      } else {
        this.btnText = 'Save Employee Transaction';
      }
    }
  }

  private getEmployee(): void {
    this.employeeTransactionService
      .getEmployees()
      .then(result => {
        this.employeeArray = result;
      });
  }

  private onSelectEmployee(selectedEmpId: number): void {
    this.selectedEmployee = this.employeeArray.filter(function (item) {
      return item.employee_id === +selectedEmpId;
    })[0];

  }

  private saveEmployeeTransaction(): void {
    let alertString: String = '';
    if (this.model.date === '') {
      alertString += ' \n select date \n';
    }
    if (this.model.type === 0) {
      alertString += 'Transaction Type\n';
    }
    if (this.model.employee_id === 0) {
      alertString += 'select Employee Name\n';
    }
    if (this.model.amount === 0) {
      alertString += 'enter Amount \n';
    }
    if (alertString !== '') {
      this.messageService.showMessage('Please ' + alertString);
      return;
    }
    this.model.type = +this.model.type;
    this.selectedEmployee.gender = +this.selectedEmployee.gender;
    let total = 0;
    total = this.model.amount + this.selectedEmployee.balance;
    if (this.model.type === TransactionType.Deposit && this.selectedEmployee.gender === Gender.Male) {
      if (this.model.amount > 24000) {
        alertString = ' ! your amount is greater than 24000, so can not Deposite ';
      } else if (this.model.amount > 15000 && this.model.pancard_no === '') {
        alertString = ' ! your amount is greater than 15000, so Pancard must ';
      } else if (total > 250000) {
        alertString = ' ! your balance is greater than 250000, so can not Deposite, you can Deposite '
          + (this.selectedEmployee.balance - this.model.amount);
      }
    } else if (this.model.type === TransactionType.Deposit && this.selectedEmployee.gender === Gender.Female) {
      if (this.model.amount > 50000) {
        alertString = ' ! your amount is greater than 50000, so can not Deposite ';
      } else if (this.model.amount > 30000 && this.model.pancard_no === '') {
        alertString = ' ! your amount is greater than 30000, so Pancard must ';
      } else if (total > 150000) {
        alertString = ' ! your balance is greater than 150000, so can not Deposite, you can Deposite '
          + (this.selectedEmployee.balance - this.model.amount);
      }
    } else if (this.model.type === TransactionType.Withdrawal && this.model.amount > this.selectedEmployee.balance) {
      alertString = 'not sufficent balance!, is ' + this.selectedEmployee.balance;
    }
    if (alertString !== '') {
      this.messageService.showMessage(this.selectedEmployee.employee_name + ' ' + alertString);
      return;
    }
    this.employeeTransactionService.saveEmployeeTransaction(this.model).then(result => {
      if (result[0].employee_id) {
        this.messageService.showMessage(this.selectedEmployee.employee_name +
          ' ! three Transaction valid at day, so now can not Deposite/Withdrawal');
      } else {
        this.messageService.showMessage(this.btnText + ' successfully');
        this.router.navigate(['/empTransaction']);
      }
    });
  }

  private getEmployeeTransactionByID(empTransationId: number): void {
    this.employeeTransactionService
      .getEmployeeTransactionByID(empTransationId)
      .then(result => {
        this.model = result;
        if (result.employee_id) {
          this.onSelectEmployee(result.employee_id);
        }
      });
  }

  private cancel() {
    this.router.navigate(['/empTransaction']);
  }
  private changeNumber(): void {
    this.showGrid = [];
    for (let i = 0, k = 1; i < +this.model.grid_number; i++) {
      this.showGrid[i] = [];
      for (let j = 0; j < +this.model.grid_number; j++ , k++) {
        this.showGrid[i][j] = new Array<any>();
        this.showGrid[i][j] = k;
        // if (i === j) {
        //   this.forwordDiagnal += k;
        //   this.backwordDiagnal = this.backwordDiagnal + this.showGrid[i][(+this.model.grid_number) - i - 1];
        // }
      }
    }
    for (let i = 0; i < +this.model.grid_number; i++) {
      for (let j = 0; j < +this.model.grid_number; j++ ) {
        if (i === j) {
          this.forwordDiagnal +=  this.showGrid[i][j];
          this.backwordDiagnal += this.showGrid[i][(+this.model.grid_number) - i - 1];
        }
      }
    }
  }
}
