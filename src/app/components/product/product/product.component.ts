import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { ProductService } from '../../../shared/services/product/product.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { Product, Item } from '../../../shared/model/product/product.model';


@Component({
    moduleId: module.id,
    selector: 'product',
    templateUrl: 'product.component.html',
})
export class ProductComponent extends BaseComponent implements OnInit {
  private model: Product;
  private itemArray: Item[] = [];
  private btnText: string;
  private productId: number;
  private selecteditem: Item;
  constructor(private productService: ProductService,
    private messageService: MessageService,
    private activatedRoute: ActivatedRoute,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
    this.model = new Product();
    this.itemArray = Array<Item>();
  }

 public ngOnInit(): void {
    if (this.user) {
      this.activatedRoute.params.subscribe(params => {
        this.productId = +params['productId']; // (+) converts string 'id' to a number
      });
      this.getItems();
      if (this.productId && this.productId !== 0) {
         this.getProductByID(this.productId);
          this.btnText = 'Update Product';
        } else {
          this.btnText = 'Save Product';
        }
    }
  }

  private getItems(): void {
    this.productService
      .getItems()
      .then(result => {
        this.itemArray = result;
      });
  }

  private onItemSelect(selectedItemId: number): void {
    this.selecteditem = this.itemArray.filter(function (item) {
      return item.items_id == selectedItemId;
    })[0];
     this.model.item_rate = parseInt(this.selecteditem.item_rate);
  }

  private saveProduct(): void {
    this.productService.saveProduct(this.model).then(result => {
      if (result) {
        this.messageService.showMessage(this.btnText + ' successfully');
        this.router.navigate(['/product']);
      } else {
        this.messageService.showMessage(this.btnText + ' successfully');
      }
    });
  }

  private getProductByID(productId: number): void {
    this.productService
      .getProductByID(productId)
      .then(result => {
        this.model = result;
         //this.model.total = result.item_rate * result.quantity;
      });
  }

  private cancel() {
    this.router.navigate(['/product']);
  }
}

