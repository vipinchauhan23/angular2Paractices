import { Component,OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { EmployeeRecord } from '../../../shared/model/employee-record/employee-record.model';
import { EmployeeRecordService } from '../../../shared/services/employee-record/employee-record.service';
import { MessageService } from '../../../shared/services/message/message.service';

@Component({
    moduleId: module.id,
    selector: 'employee-record-list',
    templateUrl: 'employee-record-list.component.html'
})
export class EmployeeRecordListComponent extends BaseComponent implements OnInit {
private selectedTravel: EmployeeRecord;
  private model: EmployeeRecord[] = [];

  constructor(private employeeRecordService: EmployeeRecordService,
   private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.selectedTravel = new EmployeeRecord();
    this.model = new Array<EmployeeRecord>();
  }

 public ngOnInit(): void {
    if (this.user) {
      this.getEmployeeRecord();
    }
  }

 private showEmployeeRecord(employeeRecordId: number): void {
    this.router.navigate(['/erecord', employeeRecordId]);
  }

 private removeItem(employeeRecordId: number): void {
    if (confirm('Are you sure you want to delete?')) {
      this.employeeRecordService
        .removeEmployeeRecord(employeeRecordId)
        .then(result => {
          if (result) {
            this.messageService.showMessage('Employee Record deleted!');
            this.getEmployeeRecord();
          } else {
            this.messageService.showMessage('Employee Record not deleted!');
          }
        });
    }
  }


  private getEmployeeRecord(): void {
    this.employeeRecordService
      .getEmployeeRecords()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
