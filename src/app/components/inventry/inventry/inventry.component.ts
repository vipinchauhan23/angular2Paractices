import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { InventryService } from '../../../shared/services/inventry/inventry.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { Inventry, Item } from '../../../shared/model/inventry/inventry.model';
import { InventryDetail } from '../../../shared/model/inventory-detail/inventory-detail.model';

@Component({
  moduleId: module.id,
  selector: 'inventry',
  templateUrl: 'inventry.component.html',
})
export class InventryComponent extends BaseComponent implements OnInit {
  private model: Inventry;
  private inventryDetailObject: InventryDetail;
  private btnText: string;
  private inventryId: number;
  private selecteditem: Item;

  private inventryType: Array<any> = [
    { inventryType_id: 1, inventryType: 'Sale' },
    { inventryType_id: 2, inventryType: 'Purchase' }
  ];

  constructor(private inventryService: InventryService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Inventry();
    this.model.inventryDetails = Array<InventryDetail>();
    this.inventryDetailObject = new InventryDetail();
    this.selecteditem = new Item();
  }

  public ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.inventryId = +params['inventryId']; // (+) converts string 'id' to a number
      });
      if (this.model.inventryDetails.length === 0) {
        this.model.inventryDetails.splice(this.model.inventryDetails.length, 0, this.inventryDetailObject);
      }
      if (this.inventryId && this.inventryId !== 0) {
        this.getInventryByID(this.inventryId);
        this.btnText = 'Update Inventry';
      } else {
        this.btnText = 'Save Inventry';
      }
    }
  }

  private addInventryDetails(): void {
    this.inventryDetailObject = new InventryDetail();
    this.model.inventryDetails.splice(this.model.inventryDetails.length, 0, this.inventryDetailObject);

  }

  private setTotal(value: number) {
    // this.model.total = value;
    this.model.total = this.model.inventryDetails.reduce(function (grandTotal, inventoryDetail) {
      return grandTotal + inventoryDetail.sub_total;
    }, 0);
  }

  private saveInventry() {

    let alertString: String = 'Please select';
    if (this.model.type === 0) {
      alertString += '\n Inventory Type \n';
    }
    if (this.model.name === '') {
      alertString += 'enter name \n';
    }
    if (this.model.address === '') {
      alertString += 'enter Adress \n';
    }
    if (this.model.mobile_no === '') {
      alertString += 'enter Mobile Number \n';
    }
    if (this.model.inventryDetails.length === 0) {
      alertString += 'select Item \n';
    }
    if (alertString !== 'Please select') {
      this.messageService.showMessage(alertString);
      return;
    }
    for (let i = 0; i < this.model.inventryDetails.length; i++) {
      for (let j = 0; j < this.model.inventryDetails.length; j++) {
        if (i !== j && this.model.inventryDetails[i].item_id === this.model.inventryDetails[j].item_id) {
             this.messageService.showMessage('Item should be unique selected!');
            return false; // means there are duplicate values
        }
      }
    }

    // this.model.inventryDetails.filter(function (item: InventryDetail) {
    //   this.model.inventryDetails.filter(function (existItem: InventryDetail) {
    //     if (item.item_id === existItem.item_id) {
    //       this.messageService.showMessage('Item should be unique selected!');
    //       return false;
    //     }
    //   }.bind(this));
    // }.bind(this));
    this.inventryService.saveInventry(this.model).then(result => {
      if (result) {
        this.messageService.showMessage(this.btnText + ' successfully');
        this.router.navigate(['/inventry']);
      } else {
        this.messageService.showMessage(this.btnText + ' successfully');
      }
    });
  }

  private getInventryByID(inventryId: number): void {
    this.inventryService
      .getInventryByID(inventryId)
      .then(result => {
        this.model = result;
      });
  }

  private cancel() {
    this.router.navigate(['/inventry']);
  }
}

