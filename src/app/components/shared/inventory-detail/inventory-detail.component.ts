import { Component, OnInit, Input,Output, EventEmitter } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { InventryService } from '../../../shared/services/inventry/inventry.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { Inventry, Item } from '../../../shared/model/inventry/inventry.model';
import {InventryDetail } from '../../../shared/model/inventory-detail/inventory-detail.model';

@Component({
    moduleId: module.id,
    selector: 'inventory-detail',
    templateUrl: 'inventory-detail.component.html',
})
export class InventoryDetailComponent extends BaseComponent implements OnInit  {

@Input() inventoryDetailModel: Array<InventryDetail>;
@Output() totalUpdated = new EventEmitter();
  private itemArray: Item[] = [];
  private selecteditem: Item;

  constructor(private inventryService: InventryService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.itemArray = Array<Item>();
    this.selecteditem = new Item();
  }

  public ngOnInit(): void {
     this.getItems();
  }
  private getItems(): void {
    this.inventryService
      .getItems()
      .then(result => {
        this.itemArray = result;
      });
  }

   private onItemSelect(selectedItemId: number, index: number): void {
    this.selecteditem = this.itemArray.filter(function (item) {

      return item.items_id === +selectedItemId;
    })[0];
    this.inventoryDetailModel[index].item_rate = parseInt(this.selecteditem.item_rate);
  }

  private changeValue(index: number) {
    if (this.inventoryDetailModel[index].quantity > 0) {
      if (this.inventoryDetailModel[index].quantity > this.selecteditem.stock) {
        alert('out of stock');
        this.inventoryDetailModel[index].quantity = 0;
      }
    }
    this.inventoryDetailModel[index].sub_total = this.inventoryDetailModel[index].item_rate * this.inventoryDetailModel[index].quantity;
    // this.model.total =  this.model.total + this.model.inventryDetails[index].sub_total;
    // let inventoryTotal = this.inventoryDetailModel.reduce(function (grandTotal, inventoryDetail) {
    //   return grandTotal + inventoryDetail.sub_total;
    // }, 0);
    this.totalUpdated.emit(this.inventoryDetailModel[index].sub_total);
  }

}
