import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { LocalStorageService } from 'angular-2-local-storage';
import { BaseComponent } from '../../base.component';
import { ProductService } from '../../../shared/services/product/product.service';
import { MessageService } from '../../../shared/services/message/message.service';
import { Product } from '../../../shared/model/product/product.model';

@Component({
    moduleId: module.id,
    selector: 'product-list',
    templateUrl: 'product-list.component.html'
})
export class ProductListComponent extends BaseComponent implements OnInit{
private selectedProduct: Product;
  private model: Product[] = [];

  constructor(private productService: ProductService, private messageService: MessageService,
    localStorageService: LocalStorageService,
    router: Router,
    location: Location) {
    super(localStorageService, router, location);
   // this.selectedProduct = new Product();
    this.model = new Array<Product>();
  }

 public ngOnInit(): void {
    if (this.user) {
      this.getProducts();
    }
  }

 private showProduct(productId: number): void {
    this.router.navigate(['/product', productId]);
  }

 private removeItem(productId: number): void {
    if (confirm('Are you sure you want to delete?')) {
      this.productService
        .removeProduct(productId)
        .then(result => {
          if (result) {
            this.messageService.showMessage('Product deleted!');
            this.getProducts();
          } else {
            this.messageService.showMessage('Product not deleted!');
          }
        });
    }
  }


  private getProducts(): void {
    this.productService
      .getProducts()
      .then(result => {
        if (result) {
          this.model = result;
        }
      });
  }
}
