import {Http} from '@angular/http';
import {Injectable} from '@angular/core';
import { ApiUrl } from '../../api-url.component';
import { Product, Item } from '../../model/product/product.model';


@Injectable()
export class ProductService {
  constructor(private http: Http) {
  }
  saveProduct(product: Product): Promise<Product[]> {
    return this
      .http
      .post(ApiUrl.baseUrl + 'saveProduct', JSON.stringify(product))
      .toPromise()
      .then(response => response.json() as Product[])
      .catch(this.handleError);
  }

getItems(): Promise<Item[]> {
    return this
      .http
      .get(ApiUrl.baseUrl + 'getItems')
      .toPromise()
      .then(response => response.json() as Item[])
      .catch(this.handleError);
  }
  getProducts(): Promise<Product[]> {
    return this.http
      .get(ApiUrl.baseUrl + 'getProducts')
      .toPromise()
      .then(response => response.json() as Product[])
      .catch(this.handleError);
  }

  getProductByID(productId: number): Promise<Product> {
    return this.http
      .get(ApiUrl.baseUrl + 'getProductByID/' + productId)
      .toPromise()
      .then(response => response.json() as Product)
      .catch(this.handleError);
  }

  removeProduct(productId: number): Promise<Product[]> {
    return this.http
      .delete(ApiUrl.baseUrl + 'deleteProduct/' + productId)
      .toPromise()
      .then(response => response.json() as Product[])
      .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
