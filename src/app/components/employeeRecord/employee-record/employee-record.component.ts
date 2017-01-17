import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { EmployeeRecord } from '../../../shared/model/employee-record/employee-record.model';
import { EmployeeRecordService } from '../../../shared/services/employee-record/employee-record.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { Qualification } from '../../../shared/model/qualification/qualification.model';
import { Employee } from '../../../shared/model/employee/employee.model';

@Component({
  moduleId: module.id,
  selector: 'employee-record',
  templateUrl: 'employee-record.component.html',
})
export class EmployeeRecordComponent extends BaseComponent implements OnInit {
  private model: EmployeeRecord;
  private employees: Employee[] = [];
  private employee: Employee;
  private qualificationArray: Qualification[] = [];
  private btnText: string;
  private employeeRecordId: number;
  constructor(private employeeRecordService: EmployeeRecordService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new EmployeeRecord();
    this.employees = Array<Employee>();
    this.employee = new Employee();
  }

  ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.employeeRecordId = +params['erecordId']; // (+) converts string 'id' to a number
      });
      this.getEmployees();
      this.getQualification();
    }
  }

  private getEmployees(): void {
    this.employeeRecordService
      .getEmployees()
      .then(result => {
        this.employees = result;
      });
  }

  private onEmployeeSelect(selectedEmployeeId: number): void {
    this.employee = this.employees.filter(function (item) {
      return item.employee_id == selectedEmployeeId;
    })[0];
  }

  private getQualification(): void {
    this.employeeRecordService
      .getQualifications()
      .then(result => {
        this.qualificationArray = result;
        if (this.employeeRecordId && this.employeeRecordId !== 0) {
          this.getEmployeeRecordByID(this.employeeRecordId);
          this.btnText = 'Update Employee Details';
        } else {
          this.btnText = 'Save Employee Details';
        }
      });
  }
  // private selectQualification(selectedQualificationId: string): void {
  //   if (this.model.selectedQualifications.length === 0) {
  //     this.model.selectedQualifications.splice(this.model.selectedQualifications.length, 0, selectedQualificationId);
  //   }
  //   else {
  //     let index = this.model.selectedQualifications.indexOf(selectedQualificationId);
  //     if (index > -1) {
  //       this.model.selectedQualifications.splice(index, 1);
  //     }
  //     else {
  //       this.model.selectedQualifications.splice(this.model.selectedQualifications.length, 0, selectedQualificationId);
  //     }
  //   }
  // }

  private saveEmployeeRecord(): void {
    this.model.selectedQualifications.length = 0;
    this.qualificationArray.map(function(item: Qualification){
      if (item.is_checked) {
      this.model.selectedQualifications.push(item.qualification_id);
      }
    }.bind(this));
    this.employeeRecordService.saveEmployeeRecord(this.model).then(result => {
      if (result) {
        this.messageService.showMessage(this.btnText + ' successfully');
        this.router.navigate(['/erecord']);
      } else {
        this.messageService.showMessage(this.btnText + ' successfully');
      }
    });
  }

  private getEmployeeRecordByID(employeeRecordId: number): void {
    this.employeeRecordService
      .getEmployeeRecordByID(employeeRecordId)
      .then(result => {
        this.model = result;
        this.onEmployeeSelect(this.model.employee_id);
        let selectedQualificationArray = new Array<number>();
        this.qualificationArray.map(function (qualification) {
         if (result.selectedQualifications.filter(function (selectedQualification: number) {
          return (qualification.qualification_id === selectedQualification );
        }).length > 0) {
           qualification.is_checked = true;
         }
        });
        this.model.selectedQualifications = selectedQualificationArray;
      });
  }
}

