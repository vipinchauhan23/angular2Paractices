import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { EmployeeTransactionService } from '../../../shared/services/employee-transaction/employee-transaction.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { EmployeeTransaction, Employee } from '../../../shared/model/employee-transaction/employee-transaction.model';

@Component({
    moduleId: module.id,
    selector: 'employee-transaction-list',
    templateUrl: 'employee-transaction-list.component.html',
})
export class EmployeeTransactionListComponent extends BaseComponent implements OnInit {
  private model: EmployeeTransaction[] = [];

  constructor(private employeeTransactionService: EmployeeTransactionService,
   private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
   // this.selectedProduct = new Product();
    this.model = new Array<EmployeeTransaction>();
  }

 public ngOnInit(): void {
    if (this.user) {
      this.getEmployeeTransactions();
    }
  }

  private showEmployeeTransaction(productId: number): void {
    this.router.navigate(['/empTransaction', productId]);
  }

 private removeItem(productId: number): void {
    if (confirm('Are you sure you want to delete?')) {
      this.employeeTransactionService
        .removeEmployeeTransaction(productId)
        .then(result => {
          if (result) {
            this.messageService.showMessage('Employee Transaction deleted!');
            this.getEmployeeTransactions();
          } else {
            this.messageService.showMessage('Employee Transaction not deleted!');
          }
        });
    }
  }


  private getEmployeeTransactions(): void {
    this.employeeTransactionService
      .getEmployeeTransactions()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
