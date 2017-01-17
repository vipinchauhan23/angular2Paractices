import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { InventryService } from '../../../shared/services/inventry/inventry.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { Inventry } from '../../../shared/model/inventry/inventry.model';

@Component({
    moduleId: module.id,
    selector: 'inventry-list',
    templateUrl: 'inventry-list.component.html'
})
export class InventryListComponent extends BaseComponent implements OnInit {
private selectedProduct: Inventry;
  private model: Inventry[] = [];

  constructor(private inventryService: InventryService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
   // this.selectedProduct = new Product();
    this.model = new Array<Inventry>();
  }

 public ngOnInit(): void {
    if (this.user) {
      this.getInventries();
    }
  }

 private showInventry(inventryId: number): void {
    this.router.navigate(['/inventry', inventryId]);
  }

 private removeItem(inventryId: number): void {
    if (confirm('Are you sure you want to delete?')) {
      this.inventryService
        .deleteInventry(inventryId)
        .then(result => {
          if (result) {
            this.messageService.showMessage('Inventry deleted!');
            this.getInventries();
          } else {
            this.messageService.showMessage('Inventry not deleted!');
          }
        });
    }
  }


  private getInventries(): void {
    this.inventryService
      .getInventries()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
